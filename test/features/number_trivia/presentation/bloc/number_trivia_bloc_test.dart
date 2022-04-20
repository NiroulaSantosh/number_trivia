import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/errors/failures.dart';
import 'package:number_trivia/core/usecase/usercase.dart';
import 'package:number_trivia/core/util/input_convertor.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:number_trivia/features/number_trivia/presentation/bloc/number_trivia/number_trivia_bloc.dart';

import 'number_trivia_bloc_test.mocks.dart';

@GenerateMocks([GetRandomNumberTrivia, GetConcreteNumberTrivia, InputConvertor])
void main() {
  late MockGetRandomNumberTrivia mockRandomNumberTrivia;
  late MockGetConcreteNumberTrivia mockConcreteNumberTrivia;
  late MockInputConvertor mockConvertor;
  late NumberTriviaBloc bloc;

  setUp(() {
    mockConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockConvertor = MockInputConvertor();

    bloc = NumberTriviaBloc(
        conceret: mockConcreteNumberTrivia,
        random: mockRandomNumberTrivia,
        inputConvertor: mockConvertor);
  });

  test('initial state should be empty', () {
    expect(bloc.state, equals(Empty()));
  });

  group('GetTriviaForConceretNumber', () {
    const String tNumberString = '1';
    final tParsedNumber = int.parse(tNumberString);
    const tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);

    void setupMockConvertorSuccess() =>
        when(mockConvertor.stringtoUnsingedInteger(any))
            .thenReturn(Right(tParsedNumber));

    void setupMockConceretNumberTrivia() => when(mockConcreteNumberTrivia(any))
        .thenAnswer((realInvocation) async => const Right(tNumberTrivia));

    test('should call the InputConvertor for converting value', () async {
      setupMockConvertorSuccess();
      setupMockConceretNumberTrivia();

      bloc.add(const GetTriviaForConcereteNumber(tNumberString));

      await untilCalled(mockConvertor.stringtoUnsingedInteger(any));

      verify(mockConvertor.stringtoUnsingedInteger(tNumberString));
    });

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'emits [Error] when invalid data is added.',
      setUp: (() {
        when(mockConvertor.stringtoUnsingedInteger(any))
            .thenAnswer((realInvocation) => Left(InvalidInputFailure()));
      }),
      build: () => bloc,
      act: (bloc) => bloc.add(const GetTriviaForConcereteNumber(tNumberString)),
      expect: () => [const Error(message: INVALID_INPUT_FAILURE_MESSAGE)],
    );

    test('should get data from the conceret use case', () async {
      setupMockConvertorSuccess();
      setupMockConceretNumberTrivia();

      bloc.add(const GetTriviaForConcereteNumber(tNumberString));

      await untilCalled(mockConcreteNumberTrivia(any));

      verify(mockConcreteNumberTrivia(Params(number: tParsedNumber)));
    });

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Loading Loaded] when data is sucessfully got',
      setUp: () {
        setupMockConvertorSuccess();
        setupMockConceretNumberTrivia();
      },
      build: () => bloc,
      act: (bloc) => bloc.add(const GetTriviaForConcereteNumber(tNumberString)),
      expect: () => [Loading(), const Loaded(trivia: tNumberTrivia)],
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Loading,Error] when getting data fails',
      setUp: () {
        setupMockConvertorSuccess();
        when(mockConcreteNumberTrivia(any))
            .thenAnswer((realInvocation) async => Left(ServerFailure()));
      },
      build: () => bloc,
      act: (bloc) => bloc.add(const GetTriviaForConcereteNumber(tNumberString)),
      expect: () => [Loading(), const Error(message: SERVER_FAILURE_MESSAGE)],
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Loading,Error] with proper message when getting data fails',
      setUp: () {
        setupMockConvertorSuccess();
        when(mockConcreteNumberTrivia(any))
            .thenAnswer((realInvocation) async => Left(ServerFailure()));
      },
      build: () => bloc,
      act: (bloc) => bloc.add(const GetTriviaForConcereteNumber(tNumberString)),
      expect: () => [Loading(), const Error(message: CACHE_FAILURE_MESSAGE)],
    );
  });

  group('GetTriviaForRandomNumber', () {
    const tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);

    void setupMockRandomNumberTrivia() => when(mockRandomNumberTrivia(any))
        .thenAnswer((realInvocation) async => const Right(tNumberTrivia));

    test('should get data from the random use case', () async {
      setupMockRandomNumberTrivia();

      bloc.add(GetTriviaForRandomNumber());

      await untilCalled(mockRandomNumberTrivia(any));

      verify(mockRandomNumberTrivia(NoParams()));
    });

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Loading Loaded] when data is sucessfully got',
      setUp: () {
        setupMockRandomNumberTrivia();
      },
      build: () => bloc,
      act: (bloc) => bloc.add(GetTriviaForRandomNumber()),
      expect: () => [Loading(), const Loaded(trivia: tNumberTrivia)],
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Loading,Error] when getting data fails',
      setUp: () {
        when(mockRandomNumberTrivia(any))
            .thenAnswer((realInvocation) async => Left(ServerFailure()));
      },
      build: () => bloc,
      act: (bloc) => bloc.add(GetTriviaForRandomNumber()),
      expect: () => [Loading(), const Error(message: SERVER_FAILURE_MESSAGE)],
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Loading,Error] with proper message when getting data fails',
      setUp: () {
        when(mockRandomNumberTrivia(any))
            .thenAnswer((realInvocation) async => Left(ServerFailure()));
      },
      build: () => bloc,
      act: (bloc) => bloc.add(GetTriviaForRandomNumber()),
      expect: () => [Loading(), const Error(message: CACHE_FAILURE_MESSAGE)],
    );
  });
}
