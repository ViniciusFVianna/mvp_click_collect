import 'dotenv/config';
import { db } from '../src/config/firebase.js';

const products = [
  {
    id: 'prod_01',
    name: 'Smartphone Galaxy A55 5G 128GB',
    description:
      'Smartphone Samsung com 8GB RAM, tela Super AMOLED de 6.6 polegadas e câmera tripla.',
    price: 1999.9,
    category: 'Eletrônicos',
    image_url: 'https://example.com/images/galaxy-a55.jpg',
    stock_by_store: {
      store_sapucaia_01: 5,
      store_canoas_01: 12,
      store_esteio_01: 2,
      store_poa_01: 20,
    },
    active: true,
  },
  {
    id: 'prod_02',
    name: 'Smart TV LED 50" 4K UHD LG',
    description:
      'Smart TV com Inteligência Artificial, HDR10 e Wi-Fi integrado.',
    price: 2499,
    category: 'Televisores',
    image_url: 'https://example.com/images/tv-lg-50.jpg',
    stock_by_store: {
      store_sapucaia_01: 2,
      store_canoas_01: 4,
      store_esteio_01: 1,
      store_poa_01: 8,
    },
    active: true,
  },
  {
    id: 'prod_03',
    name: 'Fritadeira Sem Óleo Air Fryer 4L Mondial',
    description:
      'Air Fryer com controle de temperatura até 200°C e timer de 60 minutos.',
    price: 389.9,
    category: 'Eletroportáteis',
    image_url: 'https://example.com/images/airfryer.jpg',
    stock_by_store: {
      store_sapucaia_01: 10,
      store_canoas_01: 15,
      store_esteio_01: 7,
      store_poa_01: 25,
    },
    active: true,
  },
  {
    id: 'prod_04',
    name: 'Notebook Gamer Acer Nitro 5',
    description:
      'Intel Core i5, 8GB RAM, SSD 512GB NVMe, Placa de Vídeo NVIDIA GTX 1650.',
    price: 4299,
    category: 'Informática',
    image_url: 'https://example.com/images/acer-nitro5.jpg',
    stock_by_store: {
      store_sapucaia_01: 3,
      store_canoas_01: 6,
      store_esteio_01: 0,
      store_poa_01: 10,
    },
    active: true,
  },
];

async function seedProducts() {
  const batch = db.batch();
  const productsCollection = db.collection('products');

  for (const { id, stock_by_store: stockByStore, ...product } of products) {
    batch.set(productsCollection.doc(id), product, { merge: true });

    for (const [storeId, quantity] of Object.entries(stockByStore)) {
      batch.set(
        db.collection('stores').doc(storeId).collection('stock').doc(id),
        { quantity },
        { merge: true },
      );
    }
  }

  await batch.commit();
  console.log(
    `${products.length} produtos e seus estoques gravados no Firestore.`,
  );
}

try {
  await seedProducts();
} catch (error) {
  console.error('Falha ao gravar os produtos no Firestore:', error);
  process.exitCode = 1;
} finally {
  await db.terminate();
}
