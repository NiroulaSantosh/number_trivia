part of 'number_trivia_bloc.dart';

abstract class NumberTriviaEvent extends Equatable {
  const NumberTriviaEvent();

  @override
  List<Object> get props => [];
}

class GetTriviaForConcereteNumber extends NumberTriviaEvent {
  final String numberString;

  const GetTriviaForConcereteNumber(this.numberString) : super();
}

class GetTriviaForRandomNumber extends NumberTriviaEvent {}
