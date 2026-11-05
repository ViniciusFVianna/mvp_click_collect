import { Router } from 'express';
import { notFound } from '../middlewares/not-found.js';
import ordersRoutes from '../orders/orders.routes.js';
import productsRoutes from '../products/products.routes.js';
import storesRoutes from '../stores/stores.routes.js';

const router = Router();

router.get('/', (_request, response) => {
  response.status(200).json({
    title: 'API Click & Collect',
    version: '1.0.0',
  });
});

router.get('/health', (_request, response) => {
  response.status(200).json({ status: 'ok' });
});

router.use('/api/stores', storesRoutes);
router.use('/api/products', productsRoutes);
router.use('/api/orders', ordersRoutes);
router.use(notFound);

export default router;