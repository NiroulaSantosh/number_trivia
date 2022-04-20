import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/number_trivia.dart';

abstract class NumberTriviaRepository {
  Future<Either<Failure, NumberTrivia>>? getConceretNumberTrivia(int number);
  Future<Either<Failure, NumberTrivia>>? getRandomNumberTrivia();
}
