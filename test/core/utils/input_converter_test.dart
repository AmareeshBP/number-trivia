import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/core/utils/input_converter.dart';

void main() {
  InputConverter inputConverter;
  setUp(() {
    inputConverter = InputConverter();
  });
  group('stringToUnsignedInteger', () {
    test(
      'should return integer when the string represents unsigned integer',
      () async {
        // arrange
        final String string = '123';
        // act
        final result = inputConverter.stringToUnsignedInteger(string);
        // assert
        expect(result, Right(123));
      },
    );

    test(
      'should return InvalidInputFailure when the string is not an integer',
      () async {
        // arrange
        final String string = 'abc';
        // act
        final result = inputConverter.stringToUnsignedInteger(string);
        // assert
        expect(result, Left(InvalidInputFailure()));
      },
    );

    test(
      'should return InvalidInputFalure when the string represents a negetive integer',
      () async {
        // arrange
        final String string = '-1';
        // act
        final result = inputConverter.stringToUnsignedInteger(string);
        // assert
        expect(result, Left(InvalidInputFailure()));
      },
    );
  });
}
