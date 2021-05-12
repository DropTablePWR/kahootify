import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kahootify/color_consts.dart';
import 'package:kahootify/const.dart';
import 'package:kahootify/features/manual_server_connection/bloc/manual_server_connection_bloc.dart';
import 'package:kahootify/widgets/toast.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:scan/scan.dart';
import 'package:web_socket_channel/io.dart';

class QrCodeScanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ManualServerConnectionBloc(),
      child: _QrCodeScanPage(),
    );
  }
}

class _QrCodeScanPage extends StatelessWidget {
  final scanController = ScanController();
  final textEditingController = TextEditingController();

  void connect(String ip) async {
    var socket = IOWebSocketChannel.connect("ws://$ip:$kDefaultServerPort/");
    socket.sink.add(jsonEncode({'id': 1}));
    socket.stream.listen((event) {
      print(event);
    });

    while (true) {
      await Future.delayed(Duration(seconds: 3)).then((value) => socket.sink.add(jsonEncode({'message': "player"})));
    }
  }

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: kBackgroundGreenColor),
      borderRadius: BorderRadius.circular(15.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ManualServerConnectionBloc, ManualServerConnectionState>(
      listener: (context, state) {
        if (state is BadQrState) {
          scanController.resume();
          KahootifyToast.showToast("Wrong QR Code!");
        } else if (state is BadCodeState) {
          textEditingController.clear();
          KahootifyToast.showToast("Wrong Code!");
        } else if (state is DiscoveredIp) {
          connect(state.discoveredIp);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("SCAN QR CODE"),
          backgroundColor: kBackgroundGreenColor,
        ),
        backgroundColor: kBackgroundLightColor,
        body: SizedBox.expand(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Scan a QR code visible at other players screen', style: TextStyle(fontSize: 20)),
              Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(border: Border.fromBorderSide(BorderSide(color: kBackgroundGreenColor, width: 2))),
                child: ScanView(
                  controller: scanController,
                  scanAreaScale: 1,
                  scanLineColor: kBackgroundLightColor,
                  onCapture: (code) => context.read<ManualServerConnectionBloc>().add(QrCodeScanned(code)),
                ),
              ),
              Text("You can also enter 6 digit CODE visible under the QR", style: TextStyle(fontSize: 18)),
              Container(
                width: 300,
                child: PinPut(
                  onSubmit: (code) => context.read<ManualServerConnectionBloc>().add(CodeEntered(code: code)),
                  keyboardType: TextInputType.phone,
                  separator: const SizedBox(width: 5),
                  fieldsCount: 6,
                  controller: textEditingController,
                  submittedFieldDecoration: _pinPutDecoration.copyWith(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  selectedFieldDecoration: _pinPutDecoration,
                  followingFieldDecoration: _pinPutDecoration.copyWith(
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(
                      color: kBackgroundGreenColor.withOpacity(.5),
                    ),
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
