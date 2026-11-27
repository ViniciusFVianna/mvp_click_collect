sealed class Result<S, E> {
  const Result();

  bool get isSuccess => this is Success;
  bool get isFailure => this is Failure;

  S get result => (this as Success<S, E>).value;
  E get exception => (this as Failure<S, E>).error;

  T when<T>({
    required T Function(S value) success,
    required T Function(E exception) exception,
  }) {
    if (this is Success<S, E>) {
      return success((this as Success<S, E>).value);
    }
    return exception((this as Failure<S, E>).error);
  }
}

final class Success<S, E> extends Result<S, E> {
  final S value;
  const Success(this.value);
}

final class Failure<S, E> extends Result<S, E> {
  final E error;
  const Failure(this.error);
}
