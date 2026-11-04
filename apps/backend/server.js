import 'dotenv/config';
import { createServer } from 'node:http';
import app from './src/app.js';

const port = Number(process.env.PORT ?? 3000);
const server = createServer(app);

server.listen(port, () => {
  console.log(`Backend Click & Collect disponível em http://localhost:${port}`);
});

const shutdown = () => {
  server.close(async (error) => {
    if (error) {
      console.error('Falha ao encerrar o servidor:', error);
      process.exitCode = 1;
    }
  });
};

process.on('SIGINT', shutdown);
process.on('SIGTERM', shutdown);