import { applicationDefault, getApps, initializeApp } from 'firebase-admin/app';
import { getFirestore } from 'firebase-admin/firestore';

const projectId =
  process.env.FIREBASE_PROJECT_ID ?? process.env.GOOGLE_CLOUD_PROJECT;

const firebaseApp =
  getApps()[0] ??
  initializeApp({
    credential: applicationDefault(),
    ...(projectId ? { projectId } : {}),
  });

export const db = getFirestore(firebaseApp);
