import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_clean_arch_tdd_bloc/core/network/network_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockDataConnectionChecker extends Mock implements DataConnectionChecker {}

void main() {
  NetworkInfoImpl networkInfo;
  MockDataConnectionChecker mockDataConnectionChecker;

  setUp(() {
    mockDataConnectionChecker = MockDataConnectionChecker();
    networkInfo = NetworkInfoImpl(mockDataConnectionChecker);
  });

  group('is connected', () {
    test('should forward the call to DataConnectionChecker.hasConnection',
        () async {
      final hasConnectionFuture = true;

      when(mockDataConnectionChecker.hasConnection)
          .thenAnswer((_) async => hasConnectionFuture);

      final result = await networkInfo.isConnected;

      verify(mockDataConnectionChecker.hasConnection);

      expect(result, hasConnectionFuture);
    });
  });
}
