import { Router } from 'express';
import { validateRequest } from '../middlewares/validate-request.js';
import {
  deleteProductById,
  getProduct,
  getProducts,
  postProduct,
  putProduct,
} from './products.controller.js';
import {
  createProductSchema,
  productIdParamsSchema,
  updateProductSchema,
} from './products.schema.js';

const router = Router();

router.get('/', getProducts);
router.post('/', validateRequest(createProductSchema, 'body'), postProduct);
router.get(
  '/:id',
  validateRequest(productIdParamsSchema, 'params'),
  getProduct,
);
router.put(
  '/:id',
  validateRequest(productIdParamsSchema, 'params'),
  validateRequest(updateProductSchema, 'body'),
  putProduct,
);
router.delete(
  '/:id',
  validateRequest(productIdParamsSchema, 'params'),
  deleteProductById,
);

export default router;
