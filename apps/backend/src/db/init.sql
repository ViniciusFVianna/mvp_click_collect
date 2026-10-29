PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS lojas (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL,
    endereco TEXT NOT NULL,
    cep TEXT NOT NULL,
    latitude REAL,
    longitude REAL,
    capacidade_pacotes INTEGER DEFAULT 100,
    ativo INTEGER DEFAULT 1
);

CREATE TABLE IF NOT EXISTS estoque_loja (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    loja_id INTEGER NOT NULL,
    produto_id TEXT NOT NULL,
    quantidade INTEGER NOT NULL DEFAULT 0,
    FOREIGN KEY (loja_id) REFERENCES lojas(id) ON DELETE CASCADE,
    CONSTRAINT unq_loja_produto UNIQUE (loja_id, produto_id)
);

CREATE TABLE IF NOT EXISTS pedidos (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    cliente_nome TEXT NOT NULL,
    cliente_cpf TEXT NOT NULL,
    produto_id TEXT NOT NULL,
    loja_id INTEGER NOT NULL,
    modalidade_entrega TEXT NOT NULL CHECK(modalidade_entrega IN ('ENTREGA_PADRAO', 'CLICK_COLLECT')) DEFAULT 'CLICK_COLLECT',
    status TEXT NOT NULL CHECK(status IN ('PENDENTE', 'EM_SEPARACAO', 'PRONTO_PARA_RETIRADA', 'ENTREGUE', 'CANCELADO')) DEFAULT 'PENDENTE',
    codigo_pin TEXT NOT NULL,
    codigo_qr TEXT NOT NULL,
    terceiro_autorizado_nome TEXT,
    terceiro_autorizado_cpf TEXT,
    criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
    atualizado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (loja_id) REFERENCES lojas(id)
);
