class AuthFailure {
  final String message;
  final int? statusCode;

  AuthFailure({required this.message, this.statusCode});

  factory AuthFailure.invalidCredentials() =>
      AuthFailure(message: 'E-mail ou senha inválidos.');

  factory AuthFailure.serverError([String? msg]) =>
      AuthFailure(message: msg ?? 'Erro no servidor. Tente novamente mais tarde.');

  factory AuthFailure.unknown() =>
      AuthFailure(message: 'Erro inesperado na autenticação.');
}
