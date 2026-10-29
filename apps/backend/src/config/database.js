import { mkdir, readFile } from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import sqlite3 from 'sqlite3';
import { open } from 'sqlite';

const currentDirectory = path.dirname(fileURLToPath(import.meta.url));
const defaultDatabasePath = path.resolve(currentDirectory, '../../data/click_collect.db');
const schemaPath = path.resolve(currentDirectory, '../db/init.sql');

let databasePromise;

export async function getDatabase() {
  if (!databasePromise) {
    databasePromise = initializeDatabase().catch((error) => {
      databasePromise = undefined;
      throw error;
    });
  }

  return databasePromise;
}

async function initializeDatabase() {
  const configuredPath = process.env.DATABASE_PATH ?? defaultDatabasePath;
  const databasePath = path.resolve(process.cwd(), configuredPath);
  await mkdir(path.dirname(databasePath), { recursive: true });

  const database = await open({
    filename: databasePath,
    driver: sqlite3.Database,
  });

  await database.exec('PRAGMA foreign_keys = ON; PRAGMA busy_timeout = 5000;');
  await database.exec(await readFile(schemaPath, 'utf8'));

  return database;
}

export async function closeDatabase() {
  if (!databasePromise) {
    return;
  }

  const database = await databasePromise;
  databasePromise = undefined;
  await database.close();
}