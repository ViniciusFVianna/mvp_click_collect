import { db } from '../config/firebase.js';

export async function findStoresByZipCodeAndProduct(zipCode, productId) {
  const storesSnapshot = await db
    .collection('stores')
    .where('cep', '==', zipCode)
    .get();

  const storesWithStock = await Promise.all(
    storesSnapshot.docs.map(async (storeDocument) => {
      const store = storeDocument.data();
      const stockDocument = await storeDocument.ref
        .collection('stock')
        .doc(productId)
        .get();

      return {
        id: storeDocument.id,
        name: store.name,
        address: store.address,
        cep: store.cep,
        active: store.active,
        quantity: stockDocument.exists
          ? stockDocument.data().quantity
          : 0,
      };
    }),
  );

  return storesWithStock.filter(
    (store) =>
      store.active === true &&
      Number.isInteger(store.quantity) &&
      store.quantity >= 2,
  );
}
