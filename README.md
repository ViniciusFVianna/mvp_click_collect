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

O schema canônico das tabelas `lojas`, `estoque_loja` e `pedidos` está em [`apps/backend/src/db/init.sql`](apps/backend/src/db/init.sql). Os dados demonstrativos ficam em [`apps/backend/src/db/seed.sql`](apps/backend/src/db/seed.sql). Por padrão, o banco local é criado em `apps/backend/data/click_collect.db`.

---

## 📡 Endpoints da API REST (Backend)

### **Cliente / Checkout**
| Método | Endpoint | Descrição |
| :--- | :--- | :--- |
| `GET` | `/api/stores?cep={cep}&produto_id={id}` | Lista lojas ativas com pelo menos 2 unidades do produto. A ordenação por CEP é uma aproximação, não uma distância geográfica. |
| `POST` | `/api/orders` | Cria o pedido `CLICK_COLLECT`, reserva uma unidade em transação e gera PIN e token de QR Code. |

Os endpoints de consulta de pedidos e de operação administrativa descritos no fluxo abaixo ficam para a Fase 2 do MVP. O endpoint `GET /health` verifica a disponibilidade da API.

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

# Crie as tabelas e carregue os dados demonstrativos (opcional)
npm run db:seed

# Rode a API
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
