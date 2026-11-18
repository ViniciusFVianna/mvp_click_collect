import {
  loginWithEmailAndPassword,
  refreshAdminSession,
} from './auth.service.js';

export async function login(request, response, next) {
  try {
    const session = await loginWithEmailAndPassword(request.validated.body);
    response.status(200).json({ data: session });
  } catch (error) {
    next(error);
  }
}

export async function refresh(request, response, next) {
  try {
    const session = await refreshAdminSession(request.validated.body);
    response.status(200).json({ data: session });
  } catch (error) {
    next(error);
  }
}

export function getCurrentUser(request, response) {
  response.status(200).json({ data: request.authUser });
}
