import 'dart:convert';

import 'package:app1/Features/number_trivia/Data/models/number_trivia_model.dart';
import 'package:app1/Features/number_trivia/Domain/Entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reaader.dart';

void main() {
  final tNumberTriviaModel = NumberTriviaModel(number: 1, text: "test text");

  test(
    'should be a sub class of numberTrivia entity',
    () async {
      // assert
      expect(tNumberTriviaModel, isA<NumberTrivia>());
    },
  );
  group('fromJson', () {
    test(
      'should return a valid model when jsonmodel number is an integer',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap = jsonDecode(fixture("trivia.json"));

        // act
        final result = NumberTriviaModel.fromJson(jsonMap);

        // assert
        expect(result, tNumberTriviaModel);
      },
    );
  });
  test(
    'should return a valid model when jsonmodel number is  double',
    () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          jsonDecode(fixture("trivia_double.json"));

      // act
      final result = NumberTriviaModel.fromJson(jsonMap);

      // assert
      expect(result, tNumberTriviaModel);
    },
  );

  group('toJson', () {
    test(
      'should return jsonmap containg the propoer data',
      () async {
        // arrange

        // act
        final result = tNumberTriviaModel.toJson();

        // assert
        final expectedMap = {
          "text": "test text",
          "number": 1,
        };
        expect(result, expectedMap);
      },
    );
  });
}
