abstract class Error {}

class ApiError extends Error {
  final String reason;

  ApiError(this.reason);
}
