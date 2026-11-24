import { listUserProfiles } from './users.repository.js';

export async function getUsers(request, response, next) {
  try {
    const result = await listUserProfiles(request.validated.query);
    response.status(200).json(result);
  } catch (error) {
    next(error);
  }
}
