part of 'server_discovery_bloc.dart';

@immutable
abstract class ServerDiscoveryState extends Equatable {}

class SearchingForServers extends ServerDiscoveryState {
  @override
  List<Object?> get props => [];
}

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

  @override
  List<Object?> get props => [discoveredServers, stillSearching];
}

class NoServersFound extends ServerDiscoveryState {
  @override
  List<Object?> get props => [];
}

class SearchingErrorState extends ServerDiscoveryState {
  final String reason;

  SearchingErrorState(this.reason);

  @override
  List<Object?> get props => [];
}