import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/platform/network_info.dart';

import 'network_info_test.mocks.dart';

@GenerateMocks([Connectivity])
void main() {
  late MockConnectivity mockConnectivity;
  late NetworkInfoImpl networkInfoImpl;

  setUp(() {
    mockConnectivity = MockConnectivity();
    networkInfoImpl = NetworkInfoImpl(mockConnectivity);
  });

  group('is Connected', () {
    test('should call the helper function to check the internet status', () {
      final tHasConnection = Future.value(true);
      when(mockConnectivity.checkConnectivity())
          .thenAnswer((realInvocation) async => ConnectivityResult.wifi);

      // when(networkInfoImpl.hasInternet())
      // .thenAnswer((realInvocation) async => true);

      // not wating for result
      final result = networkInfoImpl.isConnected;

      // verify(mockConnectivity.checkConnectivity());

      expect(result, equals(tHasConnection));
    });
  });
}
