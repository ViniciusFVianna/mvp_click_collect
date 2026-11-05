import { listAvailableStores } from './stores.service.js';

export async function getStores(request, response, next) {
  try {
    const stores = await listAvailableStores(request.validated.query);
    response.status(200).json({ data: stores });
  } catch (error) {
    next(error);
  }
}
