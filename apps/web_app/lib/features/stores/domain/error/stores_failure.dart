class StoresFailure {
  final String message;
  StoresFailure({required this.message});

  factory StoresFailure.unknown() =>
      StoresFailure(message: 'Erro ao carregar lojas.');
}
