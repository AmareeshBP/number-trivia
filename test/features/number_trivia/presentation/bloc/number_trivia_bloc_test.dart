import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/core/usecases/usecase.dart';
import 'package:number_trivia/core/utils/input_converter.dart';
import 'package:number_trivia/features/number_trivia/domain/entitites/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:number_trivia/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  MockInputConverter mockInputConverter;
  NumberTriviaBloc numberTriviaBloc;
  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    numberTriviaBloc = NumberTriviaBloc(
        concrete: mockGetConcreteNumberTrivia,
        random: mockGetRandomNumberTrivia,
        inputConverter: mockInputConverter);
  });

  test('initial state should be empty', () {
    expect(numberTriviaBloc.initialState, equals(Empty()));
  });

  group('getConcreteNumberTrivia', () {
    final String tNumberString = '1';
    final int tNumberParsed = 1;
    final NumberTrivia tNumberTrivia =
        NumberTrivia(number: 1, text: 'test trivia');

    void setUpMockInputConverterSuccess() =>
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Right(tNumberParsed));

    test(
      'should call the Input converter to validate and convert the string  to an unsigned integer',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        // act
        numberTriviaBloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(mockInputConverter.stringToUnsignedInteger(any));
        // assert
        verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
      },
    );

    test(
      'should emit [Error] when the value is invalid',
      () async {
        // arrange
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Left(InvalidInputFailure()));
        // assert later
        final extected = [
          Empty(),
          Error(message: INVALID_INPUT_FAILURE_MESSAGE)
        ];
        expectLater(numberTriviaBloc.state, emitsInOrder(extected));
        // act
        numberTriviaBloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
      },
    );

    test(
      'should get data from the concrete usecase',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));
        // act
        numberTriviaBloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(mockGetConcreteNumberTrivia(any));
        // assert
        verify(mockGetConcreteNumberTrivia(Params(number: tNumberParsed)));
      },
    );

    test(
      'should emit [Loading,Loaded] when data is gotten successfully',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));
        // assert later
        final expectedEmitedStates = [
          Empty(),
          Loading(),
          Loaded(numberTrivia: tNumberTrivia),
        ];
        expectLater(numberTriviaBloc.state, emitsInOrder(expectedEmitedStates));
        // act
        numberTriviaBloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
      },
    );
    test(
      'should emit [Loading,Error] when getting data fails',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Left(ServerFailure()));
        // assert later
        final expectedEmitedStates = [
          Empty(),
          Loading(),
          Error(message: SERVER_FAILURE_MESSAGE),
        ];
        expectLater(numberTriviaBloc.state, emitsInOrder(expectedEmitedStates));
        // act
        numberTriviaBloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
      },
    );

    test(
      'should emit [Loading,Error] when getting cache fails',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Left(CacheFailue()));
        // assert later
        final expectedEmitedStates = [
          Empty(),
          Loading(),
          Error(message: CACHE_FAILURE_MESSAGE),
        ];
        expectLater(numberTriviaBloc.state, emitsInOrder(expectedEmitedStates));
        // act
        numberTriviaBloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
      },
    );
  });
  group('getRandomNumberTrivia', () {
    final NumberTrivia tNumberTrivia =
        NumberTrivia(number: 1, text: 'test trivia');

    test(
      'should get data from the random usecase',
      () async {
        // arrange
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));
        // act
        numberTriviaBloc.dispatch(GetTriviaForRandomNumber());
        await untilCalled(mockGetRandomNumberTrivia(any));
        // assert
        verify(mockGetRandomNumberTrivia(NoParams()));
      },
    );

    test(
      'should emit [Loading,Loaded] when data is gotten successfully',
      () async {
        // arrange
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));
        // assert later
        final expectedEmitedStates = [
          Empty(),
          Loading(),
          Loaded(numberTrivia: tNumberTrivia),
        ];
        expectLater(numberTriviaBloc.state, emitsInOrder(expectedEmitedStates));
        // act
        numberTriviaBloc.dispatch(GetTriviaForRandomNumber());
      },
    );
    test(
      'should emit [Loading,Error] when getting data fails',
      () async {
        // arrange

        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Left(ServerFailure()));
        // assert later
        final expectedEmitedStates = [
          Empty(),
          Loading(),
          Error(message: SERVER_FAILURE_MESSAGE),
        ];
        expectLater(numberTriviaBloc.state, emitsInOrder(expectedEmitedStates));
        // act
        numberTriviaBloc.dispatch(GetTriviaForRandomNumber());
      },
    );

    test(
      'should emit [Loading,Error] when getting cache fails',
      () async {
        // arrange
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Left(CacheFailue()));
        // assert later
        final expectedEmitedStates = [
          Empty(),
          Loading(),
          Error(message: CACHE_FAILURE_MESSAGE),
        ];
        expectLater(numberTriviaBloc.state, emitsInOrder(expectedEmitedStates));
        // act
        numberTriviaBloc.dispatch(GetTriviaForRandomNumber());
      },
    );
  });
}
