import { Router } from 'express';
import { validateRequest } from '../middlewares/validate-request.js';
import { getOrders, postOrder } from './orders.controller.js';
import { createOrderSchema } from './orders.schema.js';

const router = Router();

router.post('/', validateRequest(createOrderSchema, 'body'), postOrder);
router.get('/', getOrders);

export default router;
