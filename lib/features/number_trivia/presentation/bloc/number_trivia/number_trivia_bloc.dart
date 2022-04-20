// ignore_for_file: constant_identifier_names

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:number_trivia/core/errors/failures.dart';
import 'package:number_trivia/core/usecase/usercase.dart';
import 'package:number_trivia/core/util/input_convertor.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a positive integer or zero.';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConvertor inputConvertor;
  NumberTriviaBloc(
      {required GetConcreteNumberTrivia conceret,
      required GetRandomNumberTrivia random,
      required this.inputConvertor})
      : getConcreteNumberTrivia = conceret,
        getRandomNumberTrivia = random,
        super(Empty()) {
    on<GetTriviaForConcereteNumber>((event, emit) async {
      final inputEither =
          inputConvertor.stringtoUnsingedInteger(event.numberString);

      inputEither.fold(
          (failure) =>
              emit(const Error(message: INVALID_INPUT_FAILURE_MESSAGE)),
          (integer) async {
        emit(Loading());
        final failureOrTrivia =
            await getConcreteNumberTrivia(Params(number: integer));
        await _eitherLoadedOrErrorState(failureOrTrivia, emit);
      });
    });

    on<GetTriviaForRandomNumber>((event, emit) async {
      emit(Loading());
      final failureOrTrivia = await getRandomNumberTrivia(NoParams());
      _eitherLoadedOrErrorState(failureOrTrivia, emit);
    });
  }

  Future<void> _eitherLoadedOrErrorState(Either<Failure, NumberTrivia>? either,
      Emitter<NumberTriviaState> emit) async {
    if (either == null) {
      emit(const Error(message: 'Null Data'));
    } else {
      either.fold(
          (failure) => emit(Error(message: _mapFailureToMessage(failure))),
          (trivia) => emit(Loaded(trivia: trivia)));
    }
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected Error';
    }
  }
}
