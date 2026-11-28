import { createOrder, listOrders } from './orders.service.js';

export async function getOrders(_request, response, next) {
  try {
    const orders = await listOrders();
    response.status(200).json({ data: orders });
  } catch (error) {
    next(error);
  }
}

export async function postOrder(request, response, next) {
  try {
    const order = await createOrder(request.validated.body);
    response.status(201).json({ data: order });
  } catch (error) {
    next(error);
  }
}
