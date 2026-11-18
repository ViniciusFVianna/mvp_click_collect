# Backend Click & Collect

## Login administrativo

O login usa Firebase Authentication (provedor e-mail/senha). A senha nunca é
gravada na collection Firestore `users`. Depois de autenticar, a API localiza o
perfil por `auth_uid`, pelo ID do documento igual ao UID, ou pelo e-mail
verificado. O perfil precisa conter `role: "admin"` e `active: true`.

1. Ative E-mail/senha em Firebase Authentication.
2. Crie o usuário admin no Firebase Authentication e verifique seu e-mail.
3. Configure `FIREBASE_WEB_API_KEY` no ambiente local usando a Web API key do
   projeto Firebase. Não grave esse valor em código.
4. Garanta que a collection `users` tenha o perfil admin correspondente. Os
   documentos criados pelo `seed:users` já incluem o e-mail, mas não criam uma
   conta nem senha no Firebase Authentication.

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
