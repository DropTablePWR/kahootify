abstract class Error {}

class ApiError extends Error {
  final String reason;

  ApiError(this.reason);
}

class ServerDiscoveryError {
  final String message;
  final String solutionMessage;

  ServerDiscoveryError(this.message, this.solutionMessage);
}

class NoWifiConnectionError extends ServerDiscoveryError {
  NoWifiConnectionError() : super('No Wifi!', 'Please connect to WiFi to search for servers');
}

class ServerConnectionError extends Error {}
