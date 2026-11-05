import { z } from 'zod';

export const getStoresSchema = z.object({
  cep: z
    .string()
    .regex(/^\d{5}-?\d{3}$/, 'Informe um CEP válido.')
    .transform((cep) => cep.replace('-', '')),
  produto_id: z.string().trim().min(1, 'Informe o ID do produto.'),
});
