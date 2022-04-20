import 'package:number_trivia/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:number_trivia/core/usecase/usercase.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class GetRandomNumberTrivia extends UserCase<NumberTrivia, NoParams> {
  final NumberTriviaRepository repository;
  GetRandomNumberTrivia(this.repository);
  @override
  Future<Either<Failure, NumberTrivia>?> call(NoParams params) async {
    return await repository.getRandomNumberTrivia();
  }
}
