import assert from 'node:assert/strict';
import test from 'node:test';
import { matchesAuthIdentity, toPublicUser } from './user-profile.js';

test('links a profile by uid without relying on an email claim', () => {
  assert.equal(
    matchesAuthIdentity(
      { email: 'admin@example.com' },
      'auth-user-1',
      { uid: 'auth-user-1', email_verified: false },
    ),
    true,
  );
});

test('requires a verified email when linking a profile by email', () => {
  const profile = { email: 'admin@example.com' };
  const identity = {
    uid: 'auth-user-1',
    email: 'ADMIN@example.com',
    email_verified: false,
  };

  assert.equal(matchesAuthIdentity(profile, 'profile-1', identity), false);
  assert.equal(
    matchesAuthIdentity(profile, 'profile-1', {
      ...identity,
      email_verified: true,
    }),
    true,
  );
});

test('rejects a profile explicitly linked to another Firebase uid', () => {
  assert.equal(
    matchesAuthIdentity(
      { auth_uid: 'different-user', email: 'admin@example.com' },
      'profile-1',
      {
        uid: 'auth-user-1',
        email: 'admin@example.com',
        email_verified: true,
      },
    ),
    false,
  );
});

test('does not expose credential or auth-link fields in user responses', () => {
  const user = toPublicUser('profile-1', {
    name: 'Admin',
    email: 'admin@example.com',
    role: 'admin',
    active: true,
    password: 'must-not-leak',
    auth_uid: 'private-link',
  });

  assert.deepEqual(user, {
    id: 'profile-1',
    name: 'Admin',
    email: 'admin@example.com',
    role: 'admin',
    store_id: null,
    permissions: [],
    active: true,
    created_at: null,
  });
});
