import 'package:app1/Features/number_trivia/Data/datasources/number_trivia_local_datasource.dart';
import 'package:app1/Features/number_trivia/Data/datasources/number_trivia_remote_datasource.dart';
import 'package:app1/Features/number_trivia/Data/models/number_trivia_model.dart';
import 'package:app1/Features/number_trivia/Data/repositories/number_trivia_repository_impl.dart';
import 'package:app1/Features/number_trivia/Domain/Entities/number_trivia.dart';
import 'package:app1/core/errors/exceptions.dart';
import 'package:app1/core/errors/failures.dart';
import 'package:app1/core/network/network_info.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late NumberTriviaRepositoryImpl repositoryImpl;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();

    repositoryImpl = NumberTriviaRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }
   void runTestsOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }

  group('get Concrete Number Trivia', () {
    final tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel(text: "test trivia", number: tNumber);
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;
    setUp(() {
      when(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel))
          .thenAnswer((_) async {});
      when(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
          .thenAnswer((_) async => tNumberTriviaModel);
    });
    test(
      'should check if the device is online',
      () async {
        // arrangeṭ
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // act
        repositoryImpl.getConcreteNumberTrivia(tNumber);
        // assert
        verify(() => mockNetworkInfo.isConnected);
      },
    );

    runTestsOnline( () {
  

      test(
        'should return remote data when the call to remote datasource is successfull',
        () async {
          // arrange
          when(() => mockRemoteDataSource.getConcreteNumberTrivia(any()))
              .thenAnswer((_) async => tNumberTriviaModel);

          // act
          final result = await repositoryImpl.getConcreteNumberTrivia(tNumber);

          // assert
          verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          expect(result, equals(Right(tNumberTrivia)));
        },
      );
      test(
        'should cache data locally  when the call to local datasource is successfull',
        () async {
          // arrange
          when(() => mockRemoteDataSource.getConcreteNumberTrivia(any()))
              .thenAnswer((_) async => tNumberTriviaModel);

          // act
          await repositoryImpl.getConcreteNumberTrivia(tNumber);

          // assert
          verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          verify(
              () => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
        },
      );
      test(
        'should return server failure when the call to remote datasource is Unsuccessfull',
        () async {
          // arrange
          when(() => mockRemoteDataSource.getConcreteNumberTrivia(any()))
              .thenThrow(ServerException());

          // act
          final result = await repositoryImpl.getConcreteNumberTrivia(tNumber);

          // assert
          verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
      runTestsOffline( () {
        
        test(
          'shuld return last lcally cached data when the cached data is present',
          () async {
        when(() => mockLocalDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);

        final result = await repositoryImpl.getConcreteNumberTrivia(tNumber);

        verifyZeroInteractions(mockRemoteDataSource);
        verify(() => mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(Right(tNumberTrivia)));
      });

       test(
          'shuld return CachedFailure   when there is no  cached data present',
          () async {
        when(() => mockLocalDataSource.getLastNumberTrivia())
            .thenThrow(CacheException());

        final result = await repositoryImpl.getConcreteNumberTrivia(tNumber);

        verifyZeroInteractions(mockRemoteDataSource);
        verify(() => mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(Left(CacheFailure())));
      });
      });
      
    });
  });

  group('get Random Number Trivia', () {
    
    final tNumberTriviaModel =
        NumberTriviaModel(text: "test trivia", number: 123);
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;
    setUp(() {
      when(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel))
          .thenAnswer((_) async {});
      when(() => mockRemoteDataSource.getRandomNumberTrivia())
          .thenAnswer((_) async => tNumberTriviaModel);
    });
    test(
      'should check if the device is online',
      () async {
        // arrangeṭ
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // act
        repositoryImpl.getRandomNumberTrivia();
        // assert
        verify(() => mockNetworkInfo.isConnected);
      },
    );

    runTestsOnline( () {
  

      test(
        'should return remote data when the call to remote datasource is successfull',
        () async {
          // arrange
          when(() => mockRemoteDataSource.getConcreteNumberTrivia(any()))
              .thenAnswer((_) async => tNumberTriviaModel);

          // act
          final result = await repositoryImpl.getRandomNumberTrivia();

          // assert
          verify(() => mockRemoteDataSource.getRandomNumberTrivia());
          expect(result, equals(Right(tNumberTrivia)));
        },
      );
      test(
        'should cache data locally  when the call to local datasource is successfull',
        () async {
          // arrange
          when(() => mockRemoteDataSource.getRandomNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);

          // act
          await repositoryImpl.getRandomNumberTrivia();

          // assert
          verify(() => mockRemoteDataSource.getRandomNumberTrivia());
          verify(
              () => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
        },
      );
      test(
        'should return server failure when the call to remote datasource is Unsuccessfull',
        () async {
          // arrange
          when(() => mockRemoteDataSource.getRandomNumberTrivia())
              .thenThrow(ServerException());

          // act
          final result = await repositoryImpl.getRandomNumberTrivia();

          // assert
          verify(() => mockRemoteDataSource.getRandomNumberTrivia());
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
      runTestsOffline( () {
        
        test(
          'shuld return last lcally cached data when the cached data is present',
          () async {
        when(() => mockLocalDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);

        final result = await repositoryImpl.getRandomNumberTrivia();

        verifyZeroInteractions(mockRemoteDataSource);
        verify(() => mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(Right(tNumberTrivia)));
      });

       test(
          'shuld return CachedFailure   when there is no  cached data present',
          () async {
        when(() => mockLocalDataSource.getLastNumberTrivia())
            .thenThrow(CacheException());

        final result = await repositoryImpl.getRandomNumberTrivia();

        verifyZeroInteractions(mockRemoteDataSource);
        verify(() => mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(Left(CacheFailure())));
      });
      });
      
    });
  });
}
