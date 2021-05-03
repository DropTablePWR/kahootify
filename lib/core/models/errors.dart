abstract class Error {}

class ApiError extends Error {
  final String reason;

  ApiError(this.reason);
}

class ServerDiscoveryError {
  final String message;

  ServerDiscoveryError(this.message);
}

class NoWifiConnectionError extends ServerDiscoveryError {
  NoWifiConnectionError(String message) : super(message);
}

class ServerConnectionError extends Error {}
