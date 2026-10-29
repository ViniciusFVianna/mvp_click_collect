import { getDatabase } from '../config/database.js';

let transactionQueue = Promise.resolve();

export function createWithStockReservation(order) {
  const transaction = transactionQueue.then(() => reserveAndCreate(order));
  transactionQueue = transaction.catch(() => {});
  return transaction;
}

async function reserveAndCreate(order) {
  const database = await getDatabase();
  await database.exec('BEGIN IMMEDIATE');

  try {
    const store = await database.get(
      'SELECT id FROM lojas WHERE id = ? AND ativo = 1',
      [order.loja_id],
    );

    if (!store) {
      throw Object.assign(new Error('Loja não encontrada ou inativa.'), { statusCode: 404 });
    }

    const reservation = await database.run(
      `UPDATE estoque_loja
       SET quantidade = quantidade - 1
       WHERE loja_id = ? AND produto_id = ? AND quantidade >= 2`,
      [order.loja_id, order.produto_id],
    );

    if (reservation.changes !== 1) {
      throw Object.assign(
        new Error('Estoque indisponível para retirada nesta loja.'),
        { statusCode: 409 },
      );
    }

    const result = await database.run(
      `INSERT INTO pedidos (
         cliente_nome,
         cliente_cpf,
         produto_id,
         loja_id,
         modalidade_entrega,
         status,
         codigo_pin,
         codigo_qr,
         terceiro_autorizado_nome,
         terceiro_autorizado_cpf
       ) VALUES (?, ?, ?, ?, ?, 'PENDENTE', ?, ?, ?, ?)`,
      [
        order.cliente_nome,
        order.cliente_cpf,
        order.produto_id,
        order.loja_id,
        order.modalidade_entrega,
        order.codigo_pin,
        order.codigo_qr_hash,
        order.terceiro_autorizado_nome ?? null,
        order.terceiro_autorizado_cpf ?? null,
      ],
    );

    await database.exec('COMMIT');
    return database.get(
      `SELECT
         id,
         cliente_nome,
         produto_id,
         loja_id,
         modalidade_entrega,
         status,
         terceiro_autorizado_nome,
         criado_em
       FROM pedidos
       WHERE id = ?`,
      [result.lastID],
    );
  } catch (error) {
    await database.exec('ROLLBACK');
    throw error;
  }
}
