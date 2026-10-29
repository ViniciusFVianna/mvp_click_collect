# 🛒 MegaLoja Online - Módulo Click & Collect (MVP)

Este repositório é um **monorepo** que contém a solução completa para o serviço **Click & Collect** da MegaLoja Online, desenvolvida para a disciplina de Fundamentos de Engenharia de Software (Universidade La Salle).

A solução abrange o e-commerce do cliente, o painel administrativo da loja física, a API RESTful em Node.js e o banco de dados embarcado SQLite.

---

## 📐 Visão Geral da Arquitetura

O projeto utiliza uma arquitetura baseada em microsserviços/módulos desacoplados organizados em um único repositório:

```text
megaloja-click-collect/
├── apps/
│   ├── web_app/         # Frontend em Flutter Web (E-commerce + Painel Admin)
│   └── backend/         # API RESTful em Node.js (Express + SQLite)
├── docs/                # Diagramas, Modelos e Documentação do Projeto
└── README.md            # Guia de Execução e Arquitetura do Projeto
```

---

## 🛠️ Tecnologias Utilizadas

* **Frontend:** [Flutter Web](https://flutter.dev/) (Gerenciamento de rotas com `go_router`, requisições HTTP e renderização visual de QR Code com `qr_flutter`).
* **Backend:** [Node.js](https://nodejs.org/) com [Express.js](https://expressjs.com/).
* **Banco de Dados:** [SQLite3](https://www.sqlite.org/) (SGBD relacional leve para execução local sem dependências externas).
* **Padronização REST:** JSON para troca de mensagens e respostas estruturadas com HTTP Status Codes padrão.

---

## 🗄️ Modelo de Dados (SQLite)

O arquivo de banco de dados local fica localizado em `apps/backend/data/click_collect.db`.

```sql
-- Tabela de Lojas Físicas
CREATE TABLE IF NOT EXISTS lojas (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL,
    endereco TEXT NOT NULL,
    cep TEXT NOT NULL,
    latitude REAL,
    longitude REAL
);

-- Tabela de Estoque por Loja
CREATE TABLE IF NOT EXISTS estoque_loja (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    loja_id INTEGER,
    produto_id TEXT NOT NULL,
    quantidade INTEGER NOT NULL DEFAULT 0,
    FOREIGN KEY (loja_id) REFERENCES lojas(id)
);

-- Tabela de Pedidos Click & Collect
CREATE TABLE IF NOT EXISTS pedidos (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    cliente_nome TEXT NOT NULL,
    cliente_cpf TEXT NOT NULL,
    produto_id TEXT NOT NULL,
    loja_id INTEGER,
    status TEXT CHECK(status IN ('PENDENTE', 'EM_SEPARACAO', 'PRONTO_PARA_RETIRADA', 'ENTREGUE', 'CANCELADO')) DEFAULT 'PENDENTE',
    codigo_pin TEXT NOT NULL,
    codigo_qr TEXT NOT NULL,
    criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (loja_id) REFERENCES lojas(id)
);
```

---

## 📡 Endpoints da API REST (Backend)

### **Cliente / Checkout**
| Método | Endpoint | Descrição |
| :--- | :--- | :--- |
| `GET` | `/api/stores?cep={cep}&produtoId={id}` | Lista lojas com estoque mínimo (>= 2 unidades) ordenadas por proximidade. |
| `POST` | `/api/orders` | Cria o pedido com modalidade `CLICK_COLLECT`, reserva o estoque e gera PIN/QR Code. |
| `GET` | `/api/orders/:id` | Retorna o status atual do pedido para acompanhamento do cliente. |

### **Painel Administrativo / Operação da Loja**
| Método | Endpoint | Descrição |
| :--- | :--- | :--- |
| `GET` | `/api/admin/orders?loja_id={id}` | Retorna a fila de pedidos da loja para visualização no Dashboard Kanban. |
| `PATCH` | `/api/admin/orders/:id/status` | Altera o status (`EM_SEPARACAO`, `PRONTO_PARA_RETIRADA`). |
| `POST` | `/api/admin/orders/validate` | Bipa/valida o QR Code ou PIN no balcão e altera o status para `ENTREGUE`. |

---

## 🚀 Como Executar o Projeto Localmente

### **Pré-requisitos**
* [Node.js](https://nodejs.org/) (v18 ou superior)
* [Flutter SDK](https://docs.flutter.dev/get-started/install) (v3.10 ou superior configurado para Web)

---

### **1. Executando o Backend (Node.js + SQLite)**

```bash
# Acesse a pasta do servidor
cd apps/backend

# Instale as dependências
npm install

# Inicialize o banco de dados e rode a API
npm run dev
```
> O servidor estará rodando em: `http://localhost:3000`

---

### **2. Executando o Frontend (Flutter Web)**

```bash
# Acesse a pasta do aplicativo Flutter
cd apps/web_app

# Instale os pacotes e dependências do Flutter
flutter pub get

# Execute a aplicação no navegador Chrome
flutter run -d chrome
```
> A aplicação estará acessível em: `http://localhost:8080`

---

## 🔄 Fluxo de Demonstração do MVP (End-to-End)

1. **Checkout no E-commerce (`/checkout`):**
   - O cliente finaliza a compra, escolhe *"Retirar na Loja (Grátis)"*, informa o CEP e escolhe a unidade desejada.
2. **Confirmação e Geração de Código:**
   - O sistema gera instantaneamente o **QR Code** e o **PIN de 4 dígitos**.
3. **Painel Operacional (`/admin`):**
   - A equipe da loja visualiza o pedido na coluna **"Pendentes"**, altera para **"Em Separação"** e depois para **"Pronto para Retirada"**.
4. **Validação no Balcão:**
   - O cliente exibe o QR Code/PIN no balcão da loja. O atendente insere ou bipa o código no painel admin, alterando o status para **"Entregue"** e finalizando a jornada.
