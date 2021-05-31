import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kahootify/color_const.dart';
import 'package:kahootify/core/bloc/ip_cubit.dart';
import 'package:kahootify/core/bloc/server_connection_bloc.dart';
import 'package:kahootify/features/manual_server_connection/bloc/manual_server_connection_bloc.dart';
import 'package:kahootify/features/settings/bloc/settings_cubit.dart';
import 'package:kahootify/widgets/toast.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:scan/scan.dart';

class QrCodeScanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ManualServerDiscoveryBloc(ip: context.read<IpCubit>().ip)),
        BlocProvider(create: (context) => ServerConnectionBloc(playerInfo: context.read<SettingsCubit>().playerInfo)),
      ],
      child: _QrCodeScanPage(),
    );
  }
}

class _QrCodeScanPage extends StatelessWidget {
  final scanController = ScanController();
  final textEditingController = TextEditingController();

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: KColors.backgroundGreenColor),
      borderRadius: BorderRadius.circular(15.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ManualServerDiscoveryBloc, ManualServerDiscoveryState>(listener: (context, manualServerDiscoveryState) {
          if (manualServerDiscoveryState is BadQrState) {
            scanController.resume();
            KahootifyToast.showToast("Wrong QR Code!");
          } else if (manualServerDiscoveryState is BadCodeState) {
            textEditingController.clear();
            KahootifyToast.showToast("Wrong Code!");
          } else if (manualServerDiscoveryState is DiscoveredIp) {
            context.read<ServerConnectionBloc>().add(ConnectToServerFromCode(ip: manualServerDiscoveryState.discoveredIp));
          }
        }),
        BlocListener<ServerConnectionBloc, ServerConnectState>(listener: (context, serverConnectionState) async {
          if (serverConnectionState is ConnectingToServer) {
            ServerConnectionBloc.showConnectionDialog(context);
          } else if (serverConnectionState is ConnectionSuccess) {
            Navigator.of(context).pop();
            ServerConnectionBloc.navigateToLobby(context, serverConnectionState);
          } else if (serverConnectionState is ErrorConnectingToServer) {
            await Future.delayed(Duration(seconds: 2));
            Navigator.of(context).pop();
          }
        })
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text("SCAN QR CODE"),
          backgroundColor: KColors.backgroundGreenColor,
        ),
        backgroundColor: KColors.backgroundLightColor,
        body: SizedBox.expand(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Scan a QR code visible at other players screen', style: TextStyle(fontSize: 20)),
              Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(border: Border.fromBorderSide(BorderSide(color: KColors.backgroundGreenColor, width: 2))),
                child: ScanView(
                  controller: scanController,
                  scanAreaScale: 1,
                  scanLineColor: KColors.backgroundLightColor,
                  onCapture: (code) => context.read<ManualServerDiscoveryBloc>().add(QrCodeScanned(code)),
                ),
              ),
              Text("You can also enter 6 digit CODE visible under the QR", style: TextStyle(fontSize: 18)),
              Container(
                width: 300,
                child: PinPut(
                  onSubmit: (code) => context.read<ManualServerDiscoveryBloc>().add(CodeEntered(code: code)),
                  keyboardType: TextInputType.phone,
                  separator: const SizedBox(width: 5),
                  fieldsCount: 6,
                  controller: textEditingController,
                  submittedFieldDecoration: _pinPutDecoration.copyWith(borderRadius: BorderRadius.circular(20.0)),
                  selectedFieldDecoration: _pinPutDecoration,
                  followingFieldDecoration: _pinPutDecoration.copyWith(
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(color: KColors.backgroundGreenColor.withOpacity(.5)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
