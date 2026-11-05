import { FieldValue } from 'firebase-admin/firestore';
import { db } from '../config/firebase.js';
import { HttpError } from '../errors/http-error.js';

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
