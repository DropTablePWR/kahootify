part of 'server_discovery_bloc.dart';

@immutable
abstract class ServerDiscoveryState {}

class SearchingForServers extends ServerDiscoveryState {}

class FoundServersState extends ServerDiscoveryState {
  final bool stillSearching;
  final List<ServerInfo> discoveredServers;

  FoundServersState({required this.discoveredServers, this.stillSearching = true});

  FoundServersState addServer(ServerInfo serverInfo) {
    discoveredServers.add(serverInfo);
    return FoundServersState(discoveredServers: discoveredServers);
  }

  FoundServersState endSearch() {
    return FoundServersState(discoveredServers: this.discoveredServers, stillSearching: false);
  }
}

class NoServersFound extends ServerDiscoveryState {}

class SearchingErrorState extends ServerDiscoveryState {
  final String reason;

  SearchingErrorState(this.reason);
}
