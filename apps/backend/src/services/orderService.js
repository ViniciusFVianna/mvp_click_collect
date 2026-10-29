import { createHash, randomBytes, randomInt } from 'node:crypto';
import { createWithStockReservation } from '../repositories/orderRepository.js';

export async function createOrder(orderData) {
  if (orderData.modalidade_entrega !== 'CLICK_COLLECT') {
    throw Object.assign(
      new Error('Este endpoint aceita apenas pedidos na modalidade CLICK_COLLECT.'),
      { statusCode: 422 },
    );
  }

  const pickupCode = randomBytes(32).toString('hex');
  const pin = randomInt(0, 10_000).toString().padStart(4, '0');
  const qrHash = createHash('sha256').update(pickupCode).digest('hex');

  const order = await createWithStockReservation({
    ...orderData,
    codigo_pin: pin,
    codigo_qr_hash: qrHash,
  });

  return {
    ...order,
    codigo_pin: pin,
    codigo_qr: pickupCode,
  };
}
