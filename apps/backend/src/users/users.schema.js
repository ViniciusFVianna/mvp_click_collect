import { z } from 'zod';

const userIdSchema = z
  .string()
  .trim()
  .min(1)
  .max(128)
  .refine((id) => !id.includes('/'), 'O cursor informado é inválido.');

export const listUsersSchema = z
  .object({
    email: z
      .string()
      .trim()
      .email()
      .transform((email) => email.toLowerCase())
      .optional(),
    role: z.enum(['admin', 'stock', 'client']).optional(),
    limit: z.coerce.number().int().min(1).max(100).default(50),
    cursor: userIdSchema.optional(),
  })
  .strict()
  .superRefine((query, context) => {
    if (query.email && query.role) {
      context.addIssue({
        code: z.ZodIssueCode.custom,
        message: 'Informe email ou role, não os dois.',
        path: ['email'],
      });
    }
  });
