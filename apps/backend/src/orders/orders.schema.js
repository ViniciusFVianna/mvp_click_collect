import { z } from 'zod';

const optionalCpf = z
  .string()
  .regex(/^\d{11}$/, 'O CPF deve conter exatamente 11 dígitos.')
  .optional();

export const createOrderSchema = z.object({
  cliente_nome: z.string().trim().min(3, 'Informe o nome do cliente.'),
  cliente_cpf: z
    .string()
    .regex(/^\d{11}$/, 'O CPF deve conter exatamente 11 dígitos.'),
  produto_id: z.string().trim().min(1, 'Informe o ID do produto.'),
  loja_id: z.string().trim().min(1, 'Informe o ID da loja.'),
  modalidade_entrega: z.literal('CLICK_COLLECT').default('CLICK_COLLECT'),
  terceiro_autorizado_nome: z.string().trim().optional(),
  terceiro_autorizado_cpf: optionalCpf,
});
