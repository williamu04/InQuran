sealed class SuccessOrFail<T> {}

class Success<T> extends SuccessOrFail<T> {
  final T data;
  Success(this.data);
}

class Failure<T> extends SuccessOrFail<T> {
  final String reason;
  Failure(this.reason);
}