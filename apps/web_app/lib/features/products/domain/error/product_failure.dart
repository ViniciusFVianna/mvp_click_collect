class ProductFailure implements Exception {
  final String message;

  const ProductFailure(this.message);

  factory ProductFailure.fromException(Exception exception) =>
      ProductFailure(exception.toString());

  @override
  String toString() => message;
}
