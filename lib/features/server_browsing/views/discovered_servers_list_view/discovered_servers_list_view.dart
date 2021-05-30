import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kahootify/color_const.dart';
import 'package:kahootify/features/server_browsing/bloc/server_discovery_bloc.dart';
import 'package:kahootify/features/server_browsing/views/discovered_servers_list_view/searching_error_widget.dart';

import 'discovered_servers_list_item.dart';

class ServerDiscoveryListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServerDiscoveryBloc, ServerDiscoveryState>(builder: (context, serverDiscoveryState) {
      if (serverDiscoveryState is SearchingErrorState) {
        return SearchingErrorWidget(message: serverDiscoveryState.reason, solutionMessage: serverDiscoveryState.solution);
      } else if (serverDiscoveryState is FoundServersState) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView.builder(
            itemCount: serverDiscoveryState.discoveredServers.length,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: Text('name:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500))),
                          Expanded(child: Text('players:', textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500))),
                          Expanded(child: Text('status:', textAlign: TextAlign.right, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500))),
                        ],
                      ),
                    ),
                    DiscoveredServerListItem(serverInfo: serverDiscoveryState.discoveredServers[index]),
                  ],
                );
              }
              return DiscoveredServerListItem(serverInfo: serverDiscoveryState.discoveredServers[index]);
            },
          ),
        );
      } else if (serverDiscoveryState is NoServersFound) {
        return SearchingErrorWidget(message: 'No servers found!');
      } else {
        return Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(KColors.backgroundGreenColor),
          ),
        );
      }
    });
  }
}
