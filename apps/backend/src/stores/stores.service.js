import { findStoresByZipCodeAndProduct } from './stores.repository.js';

export function listAvailableStores({ cep, produto_id }) {
  return findStoresByZipCodeAndProduct(cep, produto_id);
}
