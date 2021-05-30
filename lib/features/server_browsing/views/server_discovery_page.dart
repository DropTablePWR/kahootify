import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kahootify/color_const.dart';
import 'package:kahootify/core/bloc/server_connection_bloc.dart';
import 'package:kahootify/core/data/server_discovery_repository.dart';
import 'package:kahootify/features/manual_server_connection/views/qr_code_scan_page.dart';
import 'package:kahootify/features/server_browsing/bloc/server_discovery_bloc.dart';
import 'package:kahootify/features/server_browsing/views/discovered_servers_list_view/discovered_servers_list_view.dart';
import 'package:kahootify/features/settings/bloc/settings_cubit.dart';

class ServerDiscoveryPage extends StatelessWidget {
  static Route route() => MaterialPageRoute(builder: (context) => ServerDiscoveryPage());
  final ServerDiscoveryRepository serverDiscoveryRepository = ServerDiscoveryRepository();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ServerDiscoveryBloc>(create: (context) => ServerDiscoveryBloc(repository: serverDiscoveryRepository)),
        BlocProvider<ServerConnectionBloc>(create: (context) => ServerConnectionBloc(playerInfo: context.read<SettingsCubit>().playerInfo)),
      ],
      child: _ServerDiscoveryView(),
    );
  }
}

class _ServerDiscoveryView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<ServerConnectionBloc, ServerConnectState>(
      listener: (context, serverConnectionState) async {
        if (serverConnectionState is ConnectingToServer) {
          ServerConnectionBloc.showConnectionDialog(context);
        } else if (serverConnectionState is ConnectionSuccess) {
          Navigator.of(context).pop();
          ServerConnectionBloc.navigateToLobby(context, serverConnectionState);
        } else if (serverConnectionState is ErrorConnectingToServer) {
          await Future.delayed(Duration(seconds: 2));
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: KColors.backgroundLightColor,
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => QrCodeScanPage())),
          child: const Icon(Icons.qr_code, color: KColors.backgroundLightColor),
          backgroundColor: KColors.backgroundGreenColor,
        ),
        appBar: AppBar(
          title: Text("AVAILABLE SERVERS"),
          backgroundColor: KColors.backgroundGreenColor,
          actions: [_AppBarActions()],
        ),
        body: ServerDiscoveryListView(),
      ),
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
