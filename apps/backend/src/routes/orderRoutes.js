import { Router } from 'express';
import { postOrder } from '../controllers/orderController.js';
import { validateRequest } from '../middlewares/validateRequest.js';
import { createOrderSchema } from '../schemas/orderSchema.js';

const router = Router();

router.post('/', validateRequest(createOrderSchema), postOrder);

export default router;
