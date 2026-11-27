import { z } from 'zod';

export const getStoresSchema = z.object({
  cep: z
    .string()
    .regex(/^\d{5}-?\d{3}$/, 'Informe um CEP válido.')
    .transform((cep) => cep.replace('-', ''))
    .optional(),
  produto_id: z.string().trim().min(1, 'Informe o ID do produto.').optional(),
}).refine(
  ({ cep, produto_id }) => (cep === undefined) === (produto_id === undefined),
  {
    message: 'Informe cep e produto_id juntos para filtrar as lojas.',
    path: ['cep'],
  },
);
