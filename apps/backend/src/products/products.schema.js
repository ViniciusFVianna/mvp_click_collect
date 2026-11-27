import { z } from 'zod';

const productFields = {
  name: z.string().trim().min(1, 'Informe o nome do produto.').max(200),
  description: z
    .string()
    .trim()
    .min(1, 'Informe a descrição do produto.')
    .max(5000),
  price: z.number().finite().nonnegative('O preço não pode ser negativo.'),
  category: z.string().trim().min(1, 'Informe a categoria.').max(100),
  image_url: z.string().url('Informe uma URL de imagem válida.'),
  active: z.boolean(),
};

const productIdSchema = z
  .string()
  .trim()
  .min(1, 'Informe o ID do produto.')
  .max(128)
  .refine((id) => !id.includes('/'), 'O ID do produto não pode conter "/".');

export const createProductSchema = z
  .object({
    id: productIdSchema.optional(),
    ...productFields,
  })
  .strict();

export const updateProductSchema = z.object(productFields).strict();

export const productIdParamsSchema = z
  .object({ id: productIdSchema })
  .strict();
