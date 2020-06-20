import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia/features/number_trivia/domain/entitites/number_trivia.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final numberTriviaModel = NumberTriviaModel(number: 1, text: "Test Text");

  test(
    'should be a subclass of NumberTrivia entity',
    () async {
      // assert
      expect(numberTriviaModel, isA<NumberTrivia>());
    },
  );

  group('fromJson', () {
    test(
      'should return a valid model when the Json number is an integer',
      () async {
        // arrange
        Map<String, dynamic> jsonMap = json.decode(fixture('trivia.json'));
        // act
        final result = NumberTriviaModel.fromJson(jsonMap);
        // assert
        expect(result, numberTriviaModel);
      },
    );

    test(
      'should return a valid model when the Json number is a double',
      () async {
        // arrange
        Map<String, dynamic> jsonMap =
            json.decode(fixture('trivia_double.json'));
        // act
        final result = NumberTriviaModel.fromJson(jsonMap);
        // assert
        expect(result, numberTriviaModel);
      },
    );
  });

  group('toJson', () {
    test(
      'should return a json map containing proper data',
      () async {
        // act
        final result = numberTriviaModel.toJson();
        // assert
        final expectedMap = {
          "text": "Test Text",
          "number": 1,
        };
        expect(result, expectedMap);
      },
    );
  });
}
