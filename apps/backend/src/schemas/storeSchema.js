import { z } from 'zod';

export const getStoresSchema = z.object({
  query: z.object({
    cep: z
      .string({ required_error: 'O CEP é obrigatório para consultar lojas.' })
      .regex(/^\d{5}-?\d{3}$/, 'Formato de CEP inválido (Ex: 90020-000 ou 90020000).'),
    produto_id: z
      .string({
        required_error: 'O ID do produto é obrigatório para verificar o estoque.',
      })
      .min(1, 'Identificador do produto inválido.'),
  }),
});
