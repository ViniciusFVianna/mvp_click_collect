import { createOrder } from './orders.service.js';

export async function postOrder(request, response, next) {
  try {
    const order = await createOrder(request.validated.body);
    response.status(201).json({ data: order });
  } catch (error) {
    next(error);
  }
}
