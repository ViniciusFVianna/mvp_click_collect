# Backend Click & Collect

## Login administrativo

O login usa Firebase Authentication (provedor e-mail/senha). A senha nunca é
gravada na collection Firestore `users`. Depois de autenticar, a API localiza o
perfil por `auth_uid`, pelo ID do documento igual ao UID, ou pelo e-mail
verificado. O perfil precisa conter `role: "admin"` e `active: true`.

1. Ative E-mail/senha em Firebase Authentication.
2. Crie o usuário admin no Firebase Authentication. Em produção, confirme o
   endereço pelo link de verificação enviado pelo Firebase.
3. No arquivo `.env` deste backend, configure `FIREBASE_WEB_API_KEY` com a Web
   API key disponível em Configurações do projeto > Geral no Firebase Console.
   Essa variável precisa estar no ambiente da API (não apenas no app/painel).
   Não grave esse valor em código.
4. Garanta que a collection `users` tenha o perfil admin correspondente. Por
   padrão, `seed:users` grava somente os perfis no Firestore; não cria contas
   nem senhas no Firebase Authentication.
5. Reinicie o backend para carregar as variáveis do `.env`.

Para testes locais com uma conta admin já criada no Firebase Authentication,
é possível marcá-la como verificada usando o Admin SDK ao executar o seed:

```sh
NODE_ENV=development SEED_ADMIN_EMAIL_VERIFIED=true npm run seed:users
```

Esse comando altera o estado de verificação da conta correspondente ao admin do
seed; use-o somente em desenvolvimento/teste, nunca em produção. A conta já
precisa existir no Firebase Authentication. O script exige
`NODE_ENV=development` ou `NODE_ENV=test` para permitir essa alteração e usa
as credenciais configuradas para o Admin SDK. Ele também grava os perfis de
usuários definidos no seed no Firestore. Faça login novamente depois de
executá-lo para receber um token com a verificação atualizada.

```http
POST /api/auth/login
Content-Type: application/json

{"email":"admin@example.com","password":"<senha>"}
```

Uma resposta bem-sucedida inclui `idToken`, `refreshToken`, `expiresIn` e o
perfil público. Envie o ID token nas rotas protegidas:

```http
GET /api/users?role=stock&limit=50
Authorization: Bearer <idToken>
```

A próxima página pode ser consultada com `cursor` igual ao `nextCursor` da
resposta anterior. `POST /api/auth/refresh` recebe `{ "refreshToken": "..." }`
e retorna uma sessão atualizada. `GET /api/auth/me` retorna o perfil admin da
sessão atual.

Use HTTPS fora do desenvolvimento local e armazene os tokens de acordo com as
práticas seguras da plataforma cliente.
