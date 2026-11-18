import { Router } from 'express';
import { requireAdmin } from './auth.middleware.js';
import {
  getCurrentUser,
  login,
  refresh,
} from './auth.controller.js';
import { validateRequest } from '../middlewares/validate-request.js';
import { loginSchema, refreshSchema } from './auth.schema.js';

const router = Router();

router.post('/login', validateRequest(loginSchema, 'body'), login);
router.post('/refresh', validateRequest(refreshSchema, 'body'), refresh);
router.get('/me', requireAdmin, getCurrentUser);

export default router;
