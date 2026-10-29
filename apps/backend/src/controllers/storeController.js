import { listAvailableStores } from '../services/storeService.js';

export async function getStores(request, response, next) {
  try {
    const stores = await listAvailableStores(request.validated.query);
    response.status(200).json({ status: 'success', data: stores });
  } catch (error) {
    next(error);
  }
}
