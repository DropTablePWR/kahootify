import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kahootify/color_consts.dart';
import 'package:kahootify/core/data/server_discovery_repository.dart';
import 'package:kahootify/features/manual_server_connection/views/qr_code_scan_page.dart';
import 'package:kahootify/features/server_browsing/bloc/server_discovery_bloc.dart';
import 'package:kahootify/features/server_browsing/views/discovered_servers_list_view/discovered_servers_list_view.dart';

class ServerDiscoveryPage extends StatelessWidget {
  static Route route() => MaterialPageRoute(builder: (context) => ServerDiscoveryPage());
  final ServerDiscoveryRepository serverDiscoveryRepository = ServerDiscoveryRepository();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ServerDiscoveryBloc>(
      create: (context) => ServerDiscoveryBloc(repository: serverDiscoveryRepository),
      child: _ServerDiscoveryView(),
    );
  }
}

class _ServerDiscoveryView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundLightColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => QrCodeScanPage())),
        child: const Icon(Icons.qr_code, color: kBackgroundLightColor),
        backgroundColor: kBackgroundGreenColor,
      ),
      appBar: AppBar(
        title: Text("AVAILABLE SERVERS"),
        backgroundColor: kBackgroundGreenColor,
        actions: [_AppBarActions()],
      ),
      body: ServerDiscoveryListView(),
    );
  }
}

class _AppBarActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 20),
      child: BlocBuilder<ServerDiscoveryBloc, ServerDiscoveryState>(
        builder: (context, state) {
          if (state is SearchingErrorState || (state is FoundServersState && !state.stillSearching) || state is NoServersFound) {
            return IconButton(onPressed: () => context.read<ServerDiscoveryBloc>().add(RefreshRequested()), icon: Icon(Icons.refresh));
          } else {
            return SpinKitWave(color: Colors.white, size: 15.0);
          }
        },
      ),
    );
  }
}
