import 'dotenv/config';
import { readFile } from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { closeDatabase, getDatabase } from '../config/database.js';

const currentDirectory = path.dirname(fileURLToPath(import.meta.url));
const seedPath = path.join(currentDirectory, 'seed.sql');

try {
  const database = await getDatabase();
  const { total } = await database.get('SELECT COUNT(*) AS total FROM lojas');

  if (total > 0) {
    console.log('Seed ignorado: já existem lojas cadastradas.');
  } else {
    await database.exec('BEGIN IMMEDIATE');

    try {
      await database.exec(await readFile(seedPath, 'utf8'));
      await database.exec('COMMIT');
      console.log('Dados iniciais inseridos com sucesso.');
    } catch (error) {
      await database.exec('ROLLBACK');
      throw error;
    }
  }
} catch (error) {
  console.error('Falha ao inicializar os dados do banco:', error);
  process.exitCode = 1;
} finally {
  await closeDatabase();
}
