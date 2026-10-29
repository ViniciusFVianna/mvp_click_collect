import { getDatabase } from '../config/database.js';

export async function findAvailableByProduct(productId) {
  const database = await getDatabase();
  return database.all(
    `SELECT
       lojas.id,
       lojas.nome,
       lojas.endereco,
       lojas.cep,
       lojas.latitude,
       lojas.longitude,
       estoque_loja.quantidade AS estoque_disponivel
     FROM lojas
     INNER JOIN estoque_loja ON estoque_loja.loja_id = lojas.id
     WHERE lojas.ativo = 1
       AND estoque_loja.produto_id = ?
       AND estoque_loja.quantidade >= 2`,
    [productId],
  );
}
