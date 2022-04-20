import 'package:dartz/dartz.dart';

import '../errors/failures.dart';

class InputConvertor {
  Either<Failure, int> stringtoUnsingedInteger(String str) {
    try {
      final _parsedData = int.parse(str);
      if (_parsedData < 0) {
        throw const FormatException();
      }
      return Right(_parsedData);
    } on FormatException catch (_) {
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure {
  @override
  List<Object?> get props => [];
}
