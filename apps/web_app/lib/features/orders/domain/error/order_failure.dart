class OrderFailure implements Exception {
  final String message;

  const OrderFailure(this.message);

  factory OrderFailure.fromException(Exception exception) =>
      OrderFailure(exception.toString());

  @override
  String toString() => message;
}
