import 'dart:convert';

import 'package:app1/Features/number_trivia/Data/datasources/number_trivia_local_datasource.dart';
import 'package:app1/Features/number_trivia/Data/models/number_trivia_model.dart';
import 'package:app1/core/errors/exceptions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reaader.dart';

class MockSharedPrefrefernces extends Mock implements SharedPreferences {}

void main() {
  late NumberTriviaLocalDataSourceImpl dataSource;
  late MockSharedPrefrefernces mockSharedPrefrefernces;
  setUp(() {
    mockSharedPrefrefernces = MockSharedPrefrefernces();
    dataSource = NumberTriviaLocalDataSourceImpl(
        sharedPreferences: mockSharedPrefrefernces);
  });

  group('getlatestNumberTrivia', () {
    final tNumberTrivaiModel =
        NumberTriviaModel.fromJson(json.decode(fixture("trivia_cached.json")));
    test(
      'should return NumberTrivia from SharedPreferences when there is one',
      () async {
        // arrange
        when(() => mockSharedPrefrefernces.getString(any()))
            .thenReturn(fixture("trivia_cached.json"));

        // act
        final result = await dataSource.getLastNumberTrivia();

        // assert
        verify(() => mockSharedPrefrefernces.getString(CACHED_NUMBER_TRIVIA));
        expect(result, equals(tNumberTrivaiModel));
      },
    );
    test(
      'should throw CahceException when there is not a cached value',
      () async {
        // arrange
        when(() => mockSharedPrefrefernces.getString(any())).thenReturn(null);

        // act
        final call =  dataSource.getLastNumberTrivia;

        // assert

        expect( call, throwsA(isA<CacheException>()));
      },
    );
  });
  group('cacheNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel(number: 1, text: 'test trivia');
    test(
      'should call sharedPrefrences to cache the data',
      () async {
        when(() => mockSharedPrefrefernces.setString(any(), any()))
            .thenAnswer((_) async => true);

        dataSource.cacheNumberTrivia(tNumberTriviaModel);

        final expectedJsonString = json.encode(tNumberTriviaModel.toJson());
        verify(() => mockSharedPrefrefernces.setString(
              CACHED_NUMBER_TRIVIA,
              expectedJsonString,
            ));

        // act

        // assert
      },
    );
  });
}
