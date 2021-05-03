import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:kahootify/core/data/server_discovery_repository.dart';
import 'package:kahootify/core/models/errors.dart';
import 'package:kahootify_server/models/server_info.dart';
import 'package:meta/meta.dart';

part 'server_discovery_event.dart';
part 'server_discovery_state.dart';

class ServerDiscoveryBloc extends Bloc<ServerDiscoveryEvent, ServerDiscoveryState> {
  ServerDiscoveryBloc({required this.repository}) : super(SearchingForServers()) {
    _serverDiscoverySubscription = repository.serverDiscovery.listen((result) {
      if (result is FoundNewServer) {
        add(FoundServer(result.ip));
      } else if (result is EndOfSearch) {
        add(DiscoveryEnded());
      } else if (result is ServerDiscoveryErrorResult) {
        add(DiscoveryError(result.error));
      }
    });
  }

  final ServerDiscoveryRepository repository;
  late StreamSubscription<ServerDiscoveryStreamResult> _serverDiscoverySubscription;

  @override
  Stream<ServerDiscoveryState> mapEventToState(
    ServerDiscoveryEvent event,
  ) async* {
    if (event is FoundServer) {
      var server = await repository.getServerInfo(event.serverIp);
      if (server != null) {
        if (state is SearchingForServers) {
          yield FoundServersState(discoveredServers: [server]);
        } else if (state is FoundServersState) {
          yield (state as FoundServersState).addServer(server);
        } else {
          yield FoundServersState(discoveredServers: [server]);
        }
      }
    } else if (event is DiscoveryError) {
      yield SearchingErrorState(event.error.message);
    } else if (event is EndOfSearch) {
      if (state is FoundServersState) {
        yield (state as FoundServersState).endSearch();
      } else if (state is SearchingForServers) {
        yield NoServersFound();
      }
    } else if (event is RefreshRequested) {
      if (state is SearchingErrorState || (state is FoundServersState && !(state as FoundServersState).stillSearching)) {
        repository.startDiscovery();
        yield SearchingForServers();
      }
    }
  }

  @override
  Future<void> close() {
    _serverDiscoverySubscription.cancel();
    return super.close();
  }
}
