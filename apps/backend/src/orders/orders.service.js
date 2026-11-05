import { createHash, randomBytes, randomInt } from 'node:crypto';
import { HttpError } from '../errors/http-error.js';
import { createOrderAndReserveStock } from './orders.repository.js';

const hashCode = (code) => createHash('sha256').update(code).digest('hex');

export async function createOrder(orderInput) {
  const pin = randomInt(0, 10_000).toString().padStart(4, '0');
  const qrToken = randomBytes(32).toString('hex');
  const orderId = randomBytes(16).toString('hex');

  try {
    await createOrderAndReserveStock({
      orderId,
      storeId: orderInput.loja_id,
      productId: orderInput.produto_id,
      order: {
        customerName: orderInput.cliente_nome,
        customerCpf: orderInput.cliente_cpf,
        authorizedPersonName: orderInput.terceiro_autorizado_nome ?? null,
        authorizedPersonCpf: orderInput.terceiro_autorizado_cpf ?? null,
        deliveryMethod: orderInput.modalidade_entrega,
        pinHash: hashCode(pin),
        qrTokenHash: hashCode(qrToken),
      },
    });
  } catch (error) {
    if (error instanceof HttpError) {
      throw error;
    }
    throw error;
  }

  return { id: orderId, pin, qrToken, status: 'PENDENTE' };
}
