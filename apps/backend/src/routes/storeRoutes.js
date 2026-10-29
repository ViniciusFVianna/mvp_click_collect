import { Router } from 'express';
import { getStores } from '../controllers/storeController.js';
import { validateRequest } from '../middlewares/validateRequest.js';
import { getStoresSchema } from '../schemas/storeSchema.js';

const router = Router();

router.get('/', validateRequest(getStoresSchema), getStores);

export default router;
