import 'dotenv/config';
import app from '../src/app.js';

const port = Number(process.env.PORT ?? 3000);

if (!Number.isInteger(port) || port < 0 || port > 65_535) {
  throw new Error('PORT deve ser um número entre 0 e 65535.');
}

const server = app.listen(port, () => {
  console.log(`Backend Click & Collect disponível na porta ${port}`);
});

function shutdown(signal) {
  server.close((error) => {
    if (error) {
      console.error(`Falha ao encerrar o servidor (${signal}):`, error);
      process.exitCode = 1;
    }
  });
}

process.on('SIGINT', () => shutdown('SIGINT'));
process.on('SIGTERM', () => shutdown('SIGTERM'));