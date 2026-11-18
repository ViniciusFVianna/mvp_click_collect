import { Router } from 'express';
import { requireAdmin } from '../auth/auth.middleware.js';
import { validateRequest } from '../middlewares/validate-request.js';
import { getUsers } from './users.controller.js';
import { listUsersSchema } from './users.schema.js';

const router = Router();

router.get(
  '/',
  requireAdmin,
  validateRequest(listUsersSchema, 'query'),
  getUsers,
);

export default router;
