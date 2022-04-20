import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';

abstract class NetworkInfo extends Equatable {
  Future<bool> get isConnected;
}

class NetworkInfoImpl extends NetworkInfo {
  NetworkInfoImpl(this.connectivity);
  final Connectivity connectivity;
  @override
  Future<bool> get isConnected => _hasNetwork();

  Future<bool> _hasNetwork() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  @override
  List<Object?> get props => [connectivity, isConnected];
}
