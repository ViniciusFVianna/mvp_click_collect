import { z } from 'zod';

export const loginSchema = z
  .object({
    email: z.string().trim().email().transform((email) => email.toLowerCase()),
    password: z.string().min(1).max(4096),
  })
  .strict();

export const refreshSchema = z
  .object({
    refreshToken: z.string().trim().min(1).max(4096),
  })
  .strict();
