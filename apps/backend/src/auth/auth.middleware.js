import { getAdminSession } from './auth.service.js';
import { HttpError } from '../errors/http-error.js';

export async function requireAdmin(request, _response, next) {
  const authorization = request.get('authorization');
  const match = /^Bearer\s+(.+)$/i.exec(authorization ?? '');

  if (!match) {
    next(new HttpError(401, 'Autenticação obrigatória.'));
    return;
  }

  try {
    request.authUser = await getAdminSession(match[1]);
    next();
  } catch (error) {
    next(error);
  }
}
