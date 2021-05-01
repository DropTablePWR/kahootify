import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:kahootify/core/data/server_discovery_repository.dart';
import 'package:kahootify_server/models/server_info.dart';
import 'package:meta/meta.dart';

part 'server_discovery_event.dart';

part 'server_discovery_state.dart';

class ServerDiscoveryBloc extends Bloc<ServerDiscoveryEvent, ServerDiscoveryState> {
  ServerDiscoveryBloc({required this.repository}) : super(SearchingForServers()) {
    _serverDiscoverySubscription = repository.serverDiscovery.listen((serverIp) => add(FoundNewServer(serverIp)));
  }

  final ServerDiscoveryRepository repository;
  late StreamSubscription<String> _serverDiscoverySubscription;

  @override
  Stream<ServerDiscoveryState> mapEventToState(
    ServerDiscoveryEvent event,
  ) async* {
    if (event is FoundNewServer) {
      var info = await repository.getServerInfo(event.serverIp);
      yield info.fold((l) => SearchingError(), (r) {
        if (state is SearchingForServers) {
          return FoundServers([r]);
        } else if (state is FoundServers) {
          return (state as FoundServers).addServer(r);
        } else {
          return FoundServers([r]);
        }
      });
    }
  }

  @override
  Future<void> close() {
    _serverDiscoverySubscription.cancel();
    return super.close();
  }
}
