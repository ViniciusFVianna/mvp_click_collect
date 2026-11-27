import 'dotenv/config';
import { getAuth } from 'firebase-admin/auth';
import { db } from '../src/config/firebase.js';

const users = [
  {
    id: 'user_admin_01',
    name: 'Carlos Gerente',
    email: 'carlos.admin@megaloja.com.br',
    role: 'admin',
    store_id: null,
    permissions: [
      'manage_stores',
      'manage_products',
      'view_all_orders',
      'manage_users',
    ],
    active: true,
    created_at: '2026-01-10T10:00:00Z',
  },
  {
    id: 'user_client_01',
    name: 'Vinícius Vianna',
    email: 'vinicius.vianna@email.com',
    role: 'client',
    store_id: null,
    shipping_address: {
      street: 'Av. Sapucaia',
      number: '500',
      neighborhood: 'Centro',
      city: 'Sapucaia do Sul',
      state: 'RS',
      zip_code: '93260-010',
    },
    active: true,
    created_at: '2026-03-15T14:30:00Z',
  },
  {
    id: 'user_stock_01',
    name: 'Mariana Operacional',
    email: 'mariana.estoque@megaloja.com',
    role: 'stock',
    store_id: 'store_sapucaia_01',
    permissions: [
      'view_store_orders',
      'update_order_status',
      'validate_withdrawal_code',
    ],
    active: true,
    created_at: '2026-02-01T09:15:00Z',
  },
];

async function verifySeedAdminEmail() {
  if (process.env.SEED_ADMIN_EMAIL_VERIFIED !== 'true') {
    return;
  }

  if (!['development', 'test'].includes(process.env.NODE_ENV)) {
    throw new Error(
      'SEED_ADMIN_EMAIL_VERIFIED requer NODE_ENV=development ou NODE_ENV=test.',
    );
  }

  const adminUser = users.find((user) => user.role === 'admin');
  const auth = getAuth();
  let authUser;

  try {
    authUser = await auth.getUserByEmail(adminUser.email);
  } catch (error) {
    if (error.code === 'auth/user-not-found') {
      throw new Error(
        `Crie a conta ${adminUser.email} no Firebase Authentication antes de marcá-la como verificada.`,
        { cause: error },
      );
    }

    throw error;
  }

  if (!authUser.emailVerified) {
    await auth.updateUser(authUser.uid, { emailVerified: true });
    console.log(`E-mail do admin ${adminUser.email} marcado como verificado.`);
  }
}

async function seedUsers() {
  await verifySeedAdminEmail();

  const batch = db.batch();
  const usersCollection = db.collection('users');

  for (const { id, ...user } of users) {
    batch.set(usersCollection.doc(id), user, { merge: true });
  }

  await batch.commit();
  console.log(`${users.length} usuários gravados na coleção users.`);
}

try {
  await seedUsers();
} catch (error) {
  console.error('Falha ao executar o seed de usuários:', error);
  process.exitCode = 1;
} finally {
  await db.terminate();
}
