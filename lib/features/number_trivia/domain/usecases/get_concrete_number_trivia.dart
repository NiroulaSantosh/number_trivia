import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:number_trivia/core/usecase/usercase.dart';

import '../../../../core/errors/failures.dart';
import '../entities/number_trivia.dart';
import '../repositories/number_trivia_repository.dart';

class GetConcreteNumberTrivia extends UserCase<NumberTrivia, Params> {
  final NumberTriviaRepository repository;

  GetConcreteNumberTrivia(this.repository);

  // Future<Either<Failure, NumberTrivia>> execute({required int number}) async {
  //   return await repository.getConceretNumberTrivia(number);
  // }

  @override
  Future<Either<Failure, NumberTrivia>?> call(Params params) async {
    return await repository.getConceretNumberTrivia(params.number);
  }
}

class Params extends Equatable {
  final int number;
  const Params({required this.number});

  @override
  List<Object?> get props => [number];
}
