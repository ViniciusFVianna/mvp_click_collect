import express from 'express';
import orderRoutes from './routes/orderRoutes.js';
import storeRoutes from './routes/storeRoutes.js';

const app = express();

app.disable('x-powered-by');
app.use(express.json({ limit: '100kb' }));

app.get('/', (_request, response) => {
  response.status(200).json({ message: 'API de pedidos e lojas está funcionando.' });
});

app.get('/health', (_request, response) => {
  response.status(200).json({ status: 'success' });
});
app.use('/api/stores', storeRoutes);
app.use('/api/orders', orderRoutes);

app.use((_request, response) => {
  response.status(404).json({
    status: 'error',
    message: 'Endpoint não encontrado.',
  });
});

app.use((error, _request, response, _next) => {
  if (error.statusCode) {
    response.status(error.statusCode).json({
      status: 'error',
      message: error.message,
    });
    return;
  }

  if (error instanceof SyntaxError && error.status === 400 && 'body' in error) {
    response.status(400).json({
      status: 'error',
      message: 'O corpo da requisição contém JSON inválido.',
    });
    return;
  }

  console.error('Erro inesperado na API:', error);
  response.status(500).json({
    status: 'error',
    message: 'Erro interno do servidor.',
  });
});

export default app;