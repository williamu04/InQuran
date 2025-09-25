sealed class SuccessOrFail {}

class Success extends SuccessOrFail {}

class Failure extends SuccessOrFail {
  final String reason;
  Failure(this.reason);
}