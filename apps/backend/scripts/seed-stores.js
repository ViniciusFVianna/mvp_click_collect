import 'dotenv/config';
import { db } from '../src/config/firebase.js';

const stores = [
  {
    id: 'store_sapucaia_01',
    name: 'MegaLoja - Sapucaia Centro',
    address: {
      street: 'Av. Sapucaia',
      number: '1020',
      neighborhood: 'Centro',
      city: 'Sapucaia do Sul',
      state: 'RS',
      zip_code: '93260-000',
    },
    location: {
      latitude: -29.8275,
      longitude: -51.1468,
    },
    capacity: 35,
    current_occupancy: 12,
    opening_hours: {
      weekdays: '08:00 - 20:00',
      saturday: '08:00 - 18:00',
      sunday: 'Fechado',
    },
    active: true,
  },
  {
    id: 'store_canoas_01',
    name: 'MegaLoja - Canoas Centro',
    address: {
      street: 'Rua Tiradentes',
      number: '450',
      neighborhood: 'Centro',
      city: 'Canoas',
      state: 'RS',
      zip_code: '92010-260',
    },
    location: {
      latitude: -29.9178,
      longitude: -51.1831,
    },
    capacity: 60,
    current_occupancy: 28,
    opening_hours: {
      weekdays: '08:30 - 20:30',
      saturday: '08:30 - 19:00',
      sunday: '12:00 - 18:00',
    },
    active: true,
  },
  {
    id: 'store_esteio_01',
    name: 'MegaLoja - Esteio Centro',
    address: {
      street: 'Av. Presidente Vargas',
      number: '2100',
      neighborhood: 'Centro',
      city: 'Esteio',
      state: 'RS',
      zip_code: '93265-001',
    },
    location: {
      latitude: -29.8522,
      longitude: -51.1803,
    },
    capacity: 25,
    current_occupancy: 8,
    opening_hours: {
      weekdays: '09:00 - 19:00',
      saturday: '09:00 - 17:00',
      sunday: 'Fechado',
    },
    active: true,
  },
  {
    id: 'store_poa_01',
    name: 'MegaLoja - Porto Alegre Shopping',
    address: {
      street: 'Av. Assis Brasil',
      number: '5000',
      neighborhood: 'Sarandi',
      city: 'Porto Alegre',
      state: 'RS',
      zip_code: '91110-000',
    },
    location: {
      latitude: -30.0089,
      longitude: -51.1432,
    },
    capacity: 100,
    current_occupancy: 45,
    opening_hours: {
      weekdays: '10:00 - 22:00',
      saturday: '10:00 - 22:00',
      sunday: '14:00 - 20:00',
    },
    active: true,
  },
];

async function seedStores() {
  const batch = db.batch();
  const storesCollection = db.collection('stores');

  for (const { id, ...store } of stores) {
    batch.set(
      storesCollection.doc(id),
      {
        ...store,
        cep: store.address.zip_code.replace('-', ''),
      },
      { merge: true },
    );
  }

  await batch.commit();
  console.log(`${stores.length} lojas gravadas na coleção stores.`);
}

try {
  await seedStores();
} catch (error) {
  console.error('Falha ao gravar as lojas no Firestore:', error);
  process.exitCode = 1;
} finally {
  await db.terminate();
}
