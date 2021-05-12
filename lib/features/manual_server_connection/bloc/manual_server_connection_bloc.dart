import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kahootify_server/utils/code_converter.dart';
import 'package:wifi_iot/wifi_iot.dart';

class ManualServerConnectionBloc extends Bloc<ManualServerConnectionEvent, ManualServerConnectionState> {
  ManualServerConnectionBloc() : super(ManualServerConnectionInitial());

  @override
  Stream<ManualServerConnectionState> mapEventToState(ManualServerConnectionEvent event) async* {
    if (event is CodeEntered || event is QrCodeScanned) {
      final myIp = await WiFiForIoTPlugin.getIP();
      if (myIp == null) {
        yield NotInWifiError();
      } else {
        String? decodedIp;
        if (event is CodeEntered) {
          decodedIp = CodeConverter.decodeIp(event.code);
        } else if (event is QrCodeScanned) {
          decodedIp = CodeConverter.decodeIpFromQrCode(event.qrCode);
        }
        if (decodedIp == null) {
          if (event is CodeEntered) {
            yield BadCodeState();
          } else {
            yield BadQrState();
          }
        } else {
          final myIpParts = myIp.split('.');
          final discoveredIp = myIpParts[0] + "." + myIpParts[1] + "." + decodedIp;
          yield DiscoveredIp(discoveredIp);
        }
      }
    }
  }
}

abstract class ManualServerConnectionState {}

class ManualServerConnectionInitial extends ManualServerConnectionState {}

class BadQrState extends ManualServerConnectionState {}

class BadCodeState extends ManualServerConnectionState {}

class DiscoveredIp extends ManualServerConnectionState {
  final String discoveredIp;

  DiscoveredIp(this.discoveredIp);
}

class NotInWifiError extends ManualServerConnectionState {}

abstract class ManualServerConnectionEvent {}

class CodeEntered extends ManualServerConnectionEvent {
  final String code;

  CodeEntered({required this.code});
}

class QrCodeScanned extends ManualServerConnectionEvent {
  final String qrCode;

  QrCodeScanned(this.qrCode);
}
