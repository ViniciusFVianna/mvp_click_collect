class StoreFailure implements Exception {
  final String message;

  const StoreFailure(this.message);

  factory StoreFailure.fromException(Exception exception) =>
      StoreFailure(exception.toString());

  @override
  String toString() => message;
}
