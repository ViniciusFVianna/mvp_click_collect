import { z } from 'zod';

export const createOrderSchema = z.object({
  body: z.object({
    cliente_nome: z
      .string({ required_error: 'O nome do cliente é obrigatório.' })
      .min(3, 'O nome deve ter no mínimo 3 caracteres.'),
    cliente_cpf: z
      .string({ required_error: 'O CPF do cliente é obrigatório.' })
      .regex(/^\d{11}$/, 'O CPF deve conter exatamente 11 dígitos numéricos.'),
    produto_id: z
      .string({ required_error: 'O ID do produto é obrigatório.' })
      .min(1, 'Identificador do produto inválido.'),
    loja_id: z
      .number({ required_error: 'O ID da loja é obrigatório.' })
      .int()
      .positive('O ID da loja deve ser um número inteiro positivo.'),
    modalidade_entrega: z
      .enum(['CLICK_COLLECT', 'ENTREGA_PADRAO'], {
        invalid_type_error: 'Modalidade de entrega inválida.',
      })
      .default('CLICK_COLLECT'),
    terceiro_autorizado_nome: z.string().optional(),
    terceiro_autorizado_cpf: z
      .string()
      .regex(/^\d{11}$/, 'O CPF do terceiro autorizado deve conter 11 dígitos numéricos.')
      .optional(),
  }),
});
