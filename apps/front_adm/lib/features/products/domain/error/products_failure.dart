class ProductsFailure {
  final String message;
  ProductsFailure({required this.message});

  factory ProductsFailure.unknown() =>
      ProductsFailure(message: 'Erro ao carregar produtos.');
}
