import { getAuth } from 'firebase-admin/auth';
import { HttpError } from '../errors/http-error.js';
import { findUserProfile } from '../users/users.repository.js';
import { toPublicUser } from '../users/user-profile.js';

const invalidCredentials = new Set([
  'EMAIL_NOT_FOUND',
  'INVALID_EMAIL',
  'INVALID_LOGIN_CREDENTIALS',
  'INVALID_PASSWORD',
  'USER_DISABLED',
]);

const firebaseAuthUnavailable = new Set([
  'API_KEY_INVALID',
  'CONFIGURATION_NOT_FOUND',
  'OPERATION_NOT_ALLOWED',
  'PROJECT_NOT_FOUND',
]);

const invalidIdTokenErrors = new Set([
  'auth/argument-error',
  'auth/id-token-expired',
  'auth/id-token-revoked',
  'auth/invalid-id-token',
  'auth/invalid-user-token',
  'auth/user-disabled',
  'auth/user-not-found',
]);

function getApiKey() {
  const apiKey = process.env.FIREBASE_WEB_API_KEY?.trim();
  if (!apiKey) {
    throw new HttpError(503, 'A autenticação Firebase não está configurada.');
  }

  return apiKey;
}

async function requestFirebaseAuth(endpoint, body) {
  const apiKey = getApiKey();
  let response;
  try {
    response = await fetch(
      `https://identitytoolkit.googleapis.com/v1/${endpoint}?key=${encodeURIComponent(apiKey)}`,
      {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(body),
        signal: AbortSignal.timeout(10_000),
      },
    );
  } catch (error) {
    console.error('Falha de comunicação com Firebase Authentication:', error.name);
    throw new HttpError(502, 'Serviço de autenticação indisponível.');
  }

  let result;
  try {
    result = await response.json();
  } catch {
    throw new HttpError(502, 'Resposta inválida do serviço de autenticação.');
  }

  if (!response.ok) {
    const errorCode = result.error?.message?.split(':')[0];

    if (invalidCredentials.has(errorCode)) {
      throw new HttpError(401, 'E-mail ou senha inválidos.');
    }
    if (firebaseAuthUnavailable.has(errorCode)) {
      throw new HttpError(503, 'A autenticação Firebase não está disponível.');
    }
    if (errorCode === 'TOO_MANY_ATTEMPTS_TRY_LATER') {
      throw new HttpError(429, 'Muitas tentativas. Tente novamente mais tarde.');
    }

    throw new HttpError(502, 'Falha ao autenticar com o Firebase.');
  }

  return result;
}

async function requestFirebaseRefresh(refreshToken) {
  const apiKey = getApiKey();
  let response;
  try {
    response = await fetch(
      `https://securetoken.googleapis.com/v1/token?key=${encodeURIComponent(apiKey)}`,
      {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: new URLSearchParams({
          grant_type: 'refresh_token',
          refresh_token: refreshToken,
        }),
        signal: AbortSignal.timeout(10_000),
      },
    );
  } catch (error) {
    console.error('Falha de comunicação com Firebase Authentication:', error.name);
    throw new HttpError(502, 'Serviço de autenticação indisponível.');
  }

  let result;
  try {
    result = await response.json();
  } catch {
    throw new HttpError(502, 'Resposta inválida do serviço de autenticação.');
  }

  if (!response.ok) {
    const errorCode = result.error?.message?.split(':')[0];

    if (
      errorCode === 'INVALID_REFRESH_TOKEN' ||
      errorCode === 'TOKEN_EXPIRED' ||
      errorCode === 'USER_DISABLED'
    ) {
      throw new HttpError(401, 'Sessão inválida ou expirada.');
    }
    if (firebaseAuthUnavailable.has(errorCode)) {
      throw new HttpError(503, 'A autenticação Firebase não está disponível.');
    }

    throw new HttpError(502, 'Falha ao renovar a sessão no Firebase.');
  }

  return {
    idToken: result.id_token,
    refreshToken: result.refresh_token,
    expiresIn: result.expires_in,
  };
}

function assertAdminProfile(profile) {
  if (!profile || profile.active !== true || profile.role !== 'admin') {
    throw new HttpError(403, 'Acesso permitido somente a usuários admin ativos.');
  }

  return profile;
}

async function verifyAdminToken(idToken) {
  let identity;
  try {
    identity = await getAuth().verifyIdToken(idToken, true);
  } catch (error) {
    if (invalidIdTokenErrors.has(error.code)) {
      throw new HttpError(401, 'Sessão inválida ou expirada.');
    }
    throw error;
  }

  if (identity.email_verified !== true) {
    throw new HttpError(403, 'Verifique o e-mail antes de acessar o painel admin.');
  }

  const profile = assertAdminProfile(await findUserProfile(identity));
  return { identity, profile };
}

function sessionResponse(tokenResult, identity, profile) {
  return {
    idToken: tokenResult.idToken,
    refreshToken: tokenResult.refreshToken,
    expiresIn: tokenResult.expiresIn,
    user: toPublicUser(profile.id, profile, identity.uid),
  };
}

export async function loginWithEmailAndPassword({ email, password }) {
  const tokenResult = await requestFirebaseAuth(
    'accounts:signInWithPassword',
    { email, password, returnSecureToken: true },
  );
  const { identity, profile } = await verifyAdminToken(tokenResult.idToken);

  return sessionResponse(tokenResult, identity, profile);
}

export async function refreshAdminSession({ refreshToken }) {
  const tokenResult = await requestFirebaseRefresh(refreshToken);
  const { identity, profile } = await verifyAdminToken(tokenResult.idToken);
  return sessionResponse(tokenResult, identity, profile);
}

export async function getAdminSession(idToken) {
  const { identity, profile } = await verifyAdminToken(idToken);
  return toPublicUser(profile.id, profile, identity.uid);
}
