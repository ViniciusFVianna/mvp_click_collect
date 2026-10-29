import { findAvailableByProduct } from '../repositories/storeRepository.js';

export async function listAvailableStores({ cep, produto_id: productId }) {
  const stores = await findAvailableByProduct(productId);
  const requestedPostalCode = Number(cep.replace(/\D/g, ''));

  return stores
    .map((store) => ({
      store,
      postalCodeDifference: Math.abs(
        Number(store.cep.replace(/\D/g, '')) - requestedPostalCode,
      ),
    }))
    .sort((first, second) => first.postalCodeDifference - second.postalCodeDifference)
    .map(({ store }) => store);
}
