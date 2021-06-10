import 'package:app1/core/network/network_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mocktail/mocktail.dart';

class MockInternetConnectionChecker extends Mock
    implements InternetConnectionChecker {}

void main() {
  late MockInternetConnectionChecker mockInternetConnectionChecker;
  late NetworkInfoImpl networkInfoImpl;

  setUp(() {
    mockInternetConnectionChecker = MockInternetConnectionChecker();
    networkInfoImpl = NetworkInfoImpl(mockInternetConnectionChecker);
  });

  group('isConnected', () {
    test(
      'should forward call to internetchecker.hasconnection',
      () async {
        final tHasconnectionFuture = Future.value(true);
        // arrange
        when(() => mockInternetConnectionChecker.hasConnection)
            .thenAnswer((_)  => tHasconnectionFuture);

        // act
        final result =  networkInfoImpl.isConnected;

        // assert
        verify(() => mockInternetConnectionChecker.hasConnection);
        expect(result, tHasconnectionFuture);
      },
    );
  });
}
