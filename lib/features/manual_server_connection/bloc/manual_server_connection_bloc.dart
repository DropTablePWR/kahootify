import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kahootify_server/utils/code_converter.dart';

class ManualServerDiscoveryBloc extends Bloc<ManualServerDiscoveryEvent, ManualServerDiscoveryState> {
  ManualServerDiscoveryBloc({required this.ip}) : super(ManualServerConnectionInitial());
  final String ip;

  @override
  Stream<ManualServerDiscoveryState> mapEventToState(ManualServerDiscoveryEvent event) async* {
    if (event is CodeEntered || event is QrCodeScanned) {
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
        final myIpParts = ip.split('.');
        final discoveredIp = myIpParts[0] + "." + myIpParts[1] + "." + decodedIp;
        yield DiscoveredIp(discoveredIp);
      }
    }
  }
}

abstract class ManualServerDiscoveryState {}

class ManualServerConnectionInitial extends ManualServerDiscoveryState {}

class BadQrState extends ManualServerDiscoveryState {}

class BadCodeState extends ManualServerDiscoveryState {}

class DiscoveredIp extends ManualServerDiscoveryState {
  final String discoveredIp;

  DiscoveredIp(this.discoveredIp);
}

abstract class ManualServerDiscoveryEvent {}

class CodeEntered extends ManualServerDiscoveryEvent {
  final String code;

  CodeEntered({required this.code});
}

class QrCodeScanned extends ManualServerDiscoveryEvent {
  final String qrCode;

  QrCodeScanned(this.qrCode);
}
