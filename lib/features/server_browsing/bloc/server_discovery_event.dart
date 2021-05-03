part of 'server_discovery_bloc.dart';

@immutable
abstract class ServerDiscoveryEvent {}

class FoundServer extends ServerDiscoveryEvent {
  final String serverIp;

  FoundServer(this.serverIp);
}

class DiscoveryError extends ServerDiscoveryEvent {
  final ServerDiscoveryError error;

  DiscoveryError(this.error);
}

class DiscoveryEnded extends ServerDiscoveryEvent {}

class RefreshRequested extends ServerDiscoveryEvent {}
