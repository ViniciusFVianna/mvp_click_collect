import { Router } from 'express';
import { validateRequest } from '../middlewares/validate-request.js';
import { postOrder } from './orders.controller.js';
import { createOrderSchema } from './orders.schema.js';

const router = Router();

router.post('/', validateRequest(createOrderSchema, 'body'), postOrder);

export default router;
