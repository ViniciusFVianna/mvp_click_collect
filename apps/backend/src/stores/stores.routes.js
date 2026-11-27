import { Router } from 'express';
import { validateRequest } from '../middlewares/validate-request.js';
import { getStores } from './stores.controller.js';
import { getStoresSchema } from './stores.schema.js';

const router = Router();

router.get('/', validateRequest(getStoresSchema, 'query'), getStores);

export default router;
