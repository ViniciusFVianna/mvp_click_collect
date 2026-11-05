import { db } from '../config/firebase.js';

export async function listStores() {
  const storesSnapshot = await db.collection('stores').get();

  return storesSnapshot.docs.map((storeDocument) => {
    const store = storeDocument.data();

    return {
      ...store,
      id: storeDocument.id,
      cep: store.cep ?? store.address?.zip_code?.replace('-', ''),
    };
  });
}

export async function findStoresByZipCodeAndProduct(zipCode, productId) {
  const storesCollection = db.collection('stores');
  const formattedZipCode = `${zipCode.slice(0, 5)}-${zipCode.slice(5)}`;
  const [legacySnapshot, addressSnapshot] = await Promise.all([
    storesCollection.where('cep', '==', zipCode).get(),
    storesCollection
      .where('address.zip_code', '==', formattedZipCode)
      .get(),
  ]);
  const storesById = new Map();

  for (const document of [...legacySnapshot.docs, ...addressSnapshot.docs]) {
    storesById.set(document.id, document);
  }

  const storesWithStock = await Promise.all(
    [...storesById.values()]
      .filter((storeDocument) => storeDocument.data().active === true)
      .map(async (storeDocument) => {
        const store = storeDocument.data();
        const stockDocument = await storeDocument.ref
          .collection('stock')
          .doc(productId)
          .get();
        const storeZipCode =
          store.cep ?? store.address?.zip_code?.replace('-', '');

        return {
          id: storeDocument.id,
          name: store.name,
          address: store.address,
          cep: storeZipCode,
          active: store.active,
          quantity: stockDocument.exists
            ? stockDocument.data().quantity
            : 0,
        };
      }),
  );

  return storesWithStock.filter(
    (store) =>
      Number.isInteger(store.quantity) &&
      store.quantity >= 2,
  );
}
