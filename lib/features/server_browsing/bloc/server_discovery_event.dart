part of 'server_discovery_bloc.dart';

@immutable
abstract class ServerDiscoveryEvent {}

class FoundNewServer extends ServerDiscoveryEvent {
  final String serverIp;

  FoundNewServer(this.serverIp);
}
