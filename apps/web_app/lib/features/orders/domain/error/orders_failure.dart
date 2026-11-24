class OrdersFailure {
  final String message;
  OrdersFailure({required this.message});

  factory OrdersFailure.unknown() =>
      OrdersFailure(message: 'Erro ao processar pedidos.');
}
