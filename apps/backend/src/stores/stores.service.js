import {
  findStoresByZipCodeAndProduct,
  listStores,
} from './stores.repository.js';

export function listAvailableStores({ cep, produto_id } = {}) {
  if (cep === undefined && produto_id === undefined) {
    return listStores();
  }

  return findStoresByZipCodeAndProduct(cep, produto_id);
}
