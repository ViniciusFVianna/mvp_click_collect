import { createOrder } from '../services/orderService.js';

export async function postOrder(request, response, next) {
  try {
    const order = await createOrder(request.validated.body);
    response.status(201).json({ status: 'success', data: order });
  } catch (error) {
    next(error);
  }
}
