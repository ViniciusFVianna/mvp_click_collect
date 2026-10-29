import 'dotenv/config';
import { createServer } from 'node:http';
import app from './src/app.js';
import { closeDatabase, getDatabase } from './src/config/database.js';

const port = Number(process.env.PORT ?? 3000);
const server = createServer(app);

await getDatabase();
server.listen(port, () => {
  console.log(`Backend Click & Collect disponível em http://localhost:${port}`);
});

const shutdown = () => {
  server.close(async (error) => {
    try {
      await closeDatabase();
    } catch (databaseError) {
      console.error('Falha ao fechar a conexão com o banco de dados:', databaseError);
      process.exitCode = 1;
    }

    if (error) {
      console.error('Falha ao encerrar o servidor:', error);
      process.exitCode = 1;
    }
  });
};

process.on('SIGINT', shutdown);
process.on('SIGTERM', shutdown);