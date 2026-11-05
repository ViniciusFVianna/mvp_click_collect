const errorResponse = {
  description: 'Erro na requisição.',
  content: {
    'application/json': {
      schema: { $ref: '#/components/schemas/Error' },
      example: {
        status: 'error',
        message: 'Falha na validação dos dados de entrada.',
      },
    },
  },
};

const productBody = {
  required: true,
  content: {
    'application/json': {
      schema: { $ref: '#/components/schemas/ProductInput' },
      example: {
        name: 'Smartphone Galaxy A55 5G 128GB',
        description: 'Smartphone Samsung com 128GB de armazenamento.',
        price: 1999.9,
        category: 'Eletrônicos',
        image_url: 'https://example.com/images/galaxy-a55.jpg',
        active: true,
      },
    },
  },
};

const productIdParameter = {
  name: 'id',
  in: 'path',
  required: true,
  description: 'ID do documento do produto no Firestore.',
  schema: { type: 'string', minLength: 1, maxLength: 128 },
};

const openapi = {
  openapi: '3.0.3',
  info: {
    title: 'API Click & Collect',
    version: '1.0.0',
    description:
      'API do backend Click & Collect. As operações de produtos não exigem autenticação atualmente.',
  },
  servers: [{ url: 'http://localhost:3000', description: 'Servidor local' }],
  tags: [
    { name: 'Geral', description: 'Informações e disponibilidade da API.' },
    { name: 'Lojas', description: 'Consulta de lojas e estoque disponível.' },
    { name: 'Produtos', description: 'Cadastro e manutenção de produtos.' },
    { name: 'Pedidos', description: 'Criação de pedidos Click & Collect.' },
  ],
  paths: {
    '/': {
      get: {
        tags: ['Geral'],
        summary: 'Informações da API',
        responses: {
          200: {
            description: 'API disponível.',
            content: {
              'application/json': {
                schema: {
                  type: 'object',
                  properties: {
                    title: { type: 'string', example: 'API Click & Collect' },
                    version: { type: 'string', example: '1.0.0' },
                  },
                },
              },
            },
          },
        },
      },
    },
    '/health': {
      get: {
        tags: ['Geral'],
        summary: 'Verifica a disponibilidade da API',
        responses: {
          200: {
            description: 'API disponível.',
            content: {
              'application/json': {
                schema: {
                  type: 'object',
                  properties: { status: { type: 'string', example: 'ok' } },
                },
              },
            },
          },
        },
      },
    },
    '/api/stores': {
      get: {
        tags: ['Lojas'],
        summary: 'Lista todas as lojas ou filtra por CEP e produto',
        description:
          'Sem parâmetros, retorna todas as lojas. Para filtrar, envie cep e produto_id juntos; retorna lojas ativas com pelo menos 2 unidades do produto.',
        parameters: [
          {
            name: 'cep',
            in: 'query',
            required: false,
            description: 'CEP com ou sem hífen. Deve ser enviado com produto_id.',
            schema: { type: 'string', pattern: '^\\d{5}-?\\d{3}$' },
            example: '93260-000',
          },
          {
            name: 'produto_id',
            in: 'query',
            required: false,
            description: 'ID do produto. Deve ser enviado com cep.',
            schema: { type: 'string', minLength: 1 },
            example: 'prod_01',
          },
        ],
        responses: {
          200: {
            description: 'Lojas encontradas.',
            content: {
              'application/json': {
                schema: {
                  type: 'object',
                  properties: {
                    data: {
                      type: 'array',
                      items: { $ref: '#/components/schemas/Store' },
                    },
                  },
                },
              },
            },
          },
          400: errorResponse,
          500: { description: 'Erro interno do servidor.' },
        },
      },
    },
    '/api/products': {
      get: {
        tags: ['Produtos'],
        summary: 'Lista produtos',
        responses: {
          200: {
            description: 'Produtos encontrados.',
            content: {
              'application/json': {
                schema: {
                  type: 'object',
                  properties: {
                    data: {
                      type: 'array',
                      items: { $ref: '#/components/schemas/Product' },
                    },
                  },
                },
              },
            },
          },
          500: { description: 'Erro interno do servidor.' },
        },
      },
      post: {
        tags: ['Produtos'],
        summary: 'Cria um produto',
        description:
          'A rota é pública atualmente. O campo id é opcional; se omitido, o Firestore gera um ID.',
        requestBody: productBody,
        responses: {
          201: {
            description: 'Produto criado.',
            content: {
              'application/json': {
                schema: {
                  type: 'object',
                  properties: {
                    data: { $ref: '#/components/schemas/Product' },
                  },
                },
              },
            },
          },
          400: errorResponse,
          409: errorResponse,
          500: { description: 'Erro interno do servidor.' },
        },
      },
    },
    '/api/products/{id}': {
      parameters: [productIdParameter],
      get: {
        tags: ['Produtos'],
        summary: 'Consulta produto por ID',
        responses: {
          200: {
            description: 'Produto encontrado.',
            content: {
              'application/json': {
                schema: {
                  type: 'object',
                  properties: {
                    data: { $ref: '#/components/schemas/Product' },
                  },
                },
              },
            },
          },
          404: errorResponse,
          500: { description: 'Erro interno do servidor.' },
        },
      },
      put: {
        tags: ['Produtos'],
        summary: 'Substitui os dados de um produto',
        description:
          'Todos os campos do produto, exceto id, são obrigatórios. A rota é pública atualmente.',
        requestBody: productBody,
        responses: {
          200: {
            description: 'Produto atualizado.',
            content: {
              'application/json': {
                schema: {
                  type: 'object',
                  properties: {
                    data: { $ref: '#/components/schemas/Product' },
                  },
                },
              },
            },
          },
          400: errorResponse,
          404: errorResponse,
          500: { description: 'Erro interno do servidor.' },
        },
      },
      delete: {
        tags: ['Produtos'],
        summary: 'Exclui um produto',
        description: 'A rota é pública atualmente.',
        responses: {
          204: { description: 'Produto excluído.' },
          404: errorResponse,
          500: { description: 'Erro interno do servidor.' },
        },
      },
    },
    '/api/orders': {
      post: {
        tags: ['Pedidos'],
        summary: 'Cria pedido e reserva estoque',
        description:
          'Cria um pedido Click & Collect, reserva uma unidade em transação e retorna PIN e token QR para retirada.',
        requestBody: {
          required: true,
          content: {
            'application/json': {
              schema: { $ref: '#/components/schemas/CreateOrder' },
              example: {
                cliente_nome: 'Maria da Silva',
                cliente_cpf: '12345678901',
                produto_id: 'prod_01',
                loja_id: 'store_sapucaia_01',
                modalidade_entrega: 'CLICK_COLLECT',
              },
            },
          },
        },
        responses: {
          201: {
            description: 'Pedido criado e estoque reservado.',
            content: {
              'application/json': {
                schema: {
                  type: 'object',
                  properties: {
                    data: { $ref: '#/components/schemas/CreatedOrder' },
                  },
                },
              },
            },
          },
          400: errorResponse,
          404: errorResponse,
          409: errorResponse,
          500: { description: 'Erro interno do servidor.' },
        },
      },
    },
  },
  components: {
    schemas: {
      Error: {
        type: 'object',
        required: ['status', 'message'],
        properties: {
          status: { type: 'string', example: 'error' },
          message: { type: 'string', example: 'Produto não encontrado.' },
          errors: {
            type: 'array',
            items: {
              type: 'object',
              properties: {
                field: { type: 'string' },
                message: { type: 'string' },
              },
            },
          },
        },
      },
      Store: {
        type: 'object',
        properties: {
          id: { type: 'string', example: 'store_sapucaia_01' },
          name: { type: 'string', example: 'MegaLoja - Sapucaia Centro' },
          address: {
            type: 'object',
            properties: {
              street: { type: 'string', example: 'Av. Sapucaia' },
              number: { type: 'string', example: '1020' },
              neighborhood: { type: 'string', example: 'Centro' },
              city: { type: 'string', example: 'Sapucaia do Sul' },
              state: { type: 'string', example: 'RS' },
              zip_code: { type: 'string', example: '93260-000' },
            },
          },
          cep: { type: 'string', example: '93260000' },
          active: { type: 'boolean', example: true },
          quantity: {
            type: 'integer',
            description: 'Incluído nas respostas filtradas por CEP e produto.',
            example: 5,
          },
        },
      },
      ProductInput: {
        type: 'object',
        additionalProperties: false,
        required: [
          'name',
          'description',
          'price',
          'category',
          'image_url',
          'active',
        ],
        properties: {
          id: { type: 'string', maxLength: 128, example: 'prod_05' },
          name: { type: 'string', minLength: 1, maxLength: 200 },
          description: { type: 'string', minLength: 1, maxLength: 5000 },
          price: { type: 'number', minimum: 0, example: 1999.9 },
          category: { type: 'string', minLength: 1, maxLength: 100 },
          image_url: { type: 'string', format: 'uri' },
          active: { type: 'boolean' },
        },
      },
      Product: {
        allOf: [
          { $ref: '#/components/schemas/ProductInput' },
          {
            type: 'object',
            required: ['id'],
            properties: { id: { type: 'string', example: 'prod_01' } },
          },
        ],
      },
      CreateOrder: {
        type: 'object',
        required: ['cliente_nome', 'cliente_cpf', 'produto_id', 'loja_id'],
        properties: {
          cliente_nome: { type: 'string', minLength: 3 },
          cliente_cpf: {
            type: 'string',
            pattern: '^\\d{11}$',
            example: '12345678901',
          },
          produto_id: { type: 'string', minLength: 1 },
          loja_id: { type: 'string', minLength: 1 },
          modalidade_entrega: {
            type: 'string',
            enum: ['CLICK_COLLECT'],
            default: 'CLICK_COLLECT',
          },
          terceiro_autorizado_nome: { type: 'string' },
          terceiro_autorizado_cpf: {
            type: 'string',
            pattern: '^\\d{11}$',
          },
        },
      },
      CreatedOrder: {
        type: 'object',
        required: ['id', 'pin', 'qrToken', 'status'],
        properties: {
          id: { type: 'string' },
          pin: { type: 'string', pattern: '^\\d{4}$' },
          qrToken: { type: 'string' },
          status: { type: 'string', example: 'PENDENTE' },
        },
      },
    },
  },
};

export default openapi;
