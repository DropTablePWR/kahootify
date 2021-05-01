part of 'server_discovery_bloc.dart';

@immutable
abstract class ServerDiscoveryState {}

class SearchingForServers extends ServerDiscoveryState {}

class FoundServers extends ServerDiscoveryState {
  final List<ServerInfo> discoveredServers;

  FoundServers(this.discoveredServers);

  FoundServers addServer(ServerInfo serverInfo) {
    discoveredServers.add(serverInfo);
    return FoundServers(discoveredServers);
  }
}

class SearchingError extends ServerDiscoveryState {}
