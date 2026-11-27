import { db } from '../config/firebase.js';
import { HttpError } from '../errors/http-error.js';

const productsCollection = db.collection('products');

function toProduct(document) {
  return { ...document.data(), id: document.id };
}

export async function listProducts() {
  const snapshot = await productsCollection.get();
  return snapshot.docs.map(toProduct);
}

export async function findProductById(id) {
  const snapshot = await productsCollection.doc(id).get();

  if (!snapshot.exists) {
    throw new HttpError(404, 'Produto não encontrado.');
  }

  return toProduct(snapshot);
}

export async function createProduct(product) {
  const { id, ...productData } = product;
  const productReference = id
    ? productsCollection.doc(id)
    : productsCollection.doc();

  try {
    await productReference.create(productData);
  } catch (error) {
    if (error.code === 6 || error.code === 'already-exists') {
      throw new HttpError(409, 'Já existe um produto com esse ID.');
    }

    throw error;
  }

  return { id: productReference.id, ...productData };
}

export async function updateProduct(id, productData) {
  const productReference = productsCollection.doc(id);

  await db.runTransaction(async (transaction) => {
    const snapshot = await transaction.get(productReference);

    if (!snapshot.exists) {
      throw new HttpError(404, 'Produto não encontrado.');
    }

    transaction.set(productReference, productData);
  });

  return { id, ...productData };
}

export async function deleteProduct(id) {
  const productReference = productsCollection.doc(id);

  await db.runTransaction(async (transaction) => {
    const snapshot = await transaction.get(productReference);

    if (!snapshot.exists) {
      throw new HttpError(404, 'Produto não encontrado.');
    }

    transaction.delete(productReference);
  });
}
