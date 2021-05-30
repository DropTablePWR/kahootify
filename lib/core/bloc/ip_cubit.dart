import 'package:flutter_bloc/flutter_bloc.dart';

class IpCubit extends Cubit<String> {
  IpCubit(String initialIp) : super(initialIp);

  void setIp(String ip) => emit(ip);
}
