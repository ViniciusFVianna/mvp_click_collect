export function matchesAuthIdentity(profile, documentId, identity) {
  if (profile.auth_uid && profile.auth_uid !== identity.uid) {
    return false;
  }

  if (documentId === identity.uid || profile.auth_uid === identity.uid) {
    return true;
  }

  return (
    identity.email_verified === true &&
    typeof identity.email === 'string' &&
    typeof profile.email === 'string' &&
    profile.email.toLowerCase() === identity.email.toLowerCase()
  );
}

export function toPublicUser(profileId, profile, uid = undefined) {
  return {
    id: profileId,
    ...(uid ? { uid } : {}),
    name: profile.name ?? null,
    email: profile.email ?? null,
    role: profile.role ?? null,
    store_id: profile.store_id ?? null,
    permissions: Array.isArray(profile.permissions) ? profile.permissions : [],
    active: profile.active === true,
    created_at: profile.created_at ?? null,
  };
}
