import { FieldPath } from 'firebase-admin/firestore';
import { db } from '../config/firebase.js';
import { HttpError } from '../errors/http-error.js';
import { matchesAuthIdentity, toPublicUser } from './user-profile.js';

const usersCollection = db.collection('users');

export async function findUserProfile(identity) {
  const directMatch = await usersCollection.doc(identity.uid).get();
  if (directMatch.exists) {
    const profile = directMatch.data();
    return matchesAuthIdentity(profile, directMatch.id, identity)
      ? { id: directMatch.id, ...profile }
      : null;
  }

  const authUidMatches = await usersCollection
    .where('auth_uid', '==', identity.uid)
    .limit(2)
    .get();

  if (authUidMatches.size > 1) {
    throw new HttpError(409, 'Há mais de um perfil vinculado a esta conta.');
  }
  if (!authUidMatches.empty) {
    const profileDocument = authUidMatches.docs[0];
    return { id: profileDocument.id, ...profileDocument.data() };
  }

  if (identity.email_verified !== true || !identity.email) {
    return null;
  }

  const emailMatches = await usersCollection
    .where('email', '==', identity.email.toLowerCase())
    .limit(2)
    .get();

  if (emailMatches.size > 1) {
    throw new HttpError(409, 'Há mais de um perfil com este e-mail.');
  }
  if (emailMatches.empty) {
    return null;
  }

  const profileDocument = emailMatches.docs[0];
  const profile = profileDocument.data();

  return matchesAuthIdentity(profile, profileDocument.id, identity)
    ? { id: profileDocument.id, ...profile }
    : null;
}

export async function listUserProfiles({ email, role, limit, cursor }) {
  let query = usersCollection.orderBy(FieldPath.documentId());

  if (email) {
    query = query.where('email', '==', email);
  } else if (role) {
    query = query.where('role', '==', role);
  }

  if (cursor) {
    query = query.startAfter(cursor);
  }

  const snapshot = await query.limit(limit + 1).get();
  const page = snapshot.docs.slice(0, limit);

  return {
    data: page.map((document) => toPublicUser(document.id, document.data())),
    nextCursor:
      snapshot.docs.length > limit ? page[page.length - 1].id : null,
  };
}
