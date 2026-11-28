import { FieldValue } from 'firebase-admin/firestore';
import { db } from '../config/firebase.js';
import { HttpError } from '../errors/http-error.js';

const ordersCollection = db.collection('orders');

function toTimestamp(value) {
  if (value?.toDate instanceof Function) {
    return value.toDate().toISOString();
  }
  if (value instanceof Date) {
    return value.toISOString();
  }
  return value ?? null;
}

function toPublicOrder(document) {
  const order = document.data();

  return {
    id: document.id,
    cliente_nome: order.customerName ?? order.cliente_nome ?? null,
    cliente_cpf: order.customerCpf ?? order.cliente_cpf ?? null,
    terceiro_autorizado_nome:
      order.authorizedPersonName ?? order.terceiro_autorizado_nome ?? null,
    terceiro_autorizado_cpf:
      order.authorizedPersonCpf ?? order.terceiro_autorizado_cpf ?? null,
    produto_id: order.productId ?? order.produto_id ?? null,
    loja_id: order.storeId ?? order.loja_id ?? null,
    modalidade_entrega:
      order.deliveryMethod ?? order.modalidade_entrega ?? 'CLICK_COLLECT',
    status: order.status ?? 'PENDENTE',
    created_at: toTimestamp(order.createdAt),
  };
}

export async function listOrders() {
  const snapshot = await ordersCollection.get();
  return snapshot.docs.map(toPublicOrder);
}

export async function createOrderAndReserveStock({
  orderId,
  storeId,
  productId,
  order,
}) {
  const storeReference = db.collection('stores').doc(storeId);
  const stockReference = storeReference
    .collection('stock')
    .doc(productId);
  const orderReference = db.collection('orders').doc(orderId);

  await db.runTransaction(async (transaction) => {
    const [storeSnapshot, stockSnapshot] = await Promise.all([
      transaction.get(storeReference),
      transaction.get(stockReference),
    ]);

    if (!storeSnapshot.exists || storeSnapshot.data().active !== true) {
      throw new HttpError(404, 'Loja não encontrada ou inativa.');
    }

    const quantity = stockSnapshot.exists
      ? stockSnapshot.data().quantity
      : 0;

    if (!Number.isInteger(quantity) || quantity < 2) {
      throw new HttpError(409, 'Estoque insuficiente para reservar o pedido.');
    }

    transaction.update(stockReference, { quantity: quantity - 1 });
    transaction.create(orderReference, {
      ...order,
      storeId,
      productId,
      status: 'PENDENTE',
      createdAt: FieldValue.serverTimestamp(),
      updatedAt: FieldValue.serverTimestamp(),
    });
  });
}
