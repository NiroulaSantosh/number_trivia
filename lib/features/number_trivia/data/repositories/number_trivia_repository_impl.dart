import 'package:dartz/dartz.dart';
import 'package:number_trivia/core/errors/exceptions.dart';

import 'package:number_trivia/core/errors/failures.dart';
import 'package:number_trivia/core/platform/network_info.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';

typedef _ConceretOrRandomNumberChooser = Future<NumberTriviaModal> Function();

class NumberTriviaRepositoryImpl extends NumberTriviaRepository {
  final NumberTriviaLocalDataSource localDataSource;
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, NumberTrivia>>? getConceretNumberTrivia(
      int number) async {
    return await _getTrivia(
        () => remoteDataSource.getConcereteNumberTrivia(number));
  }

  @override
  Future<Either<Failure, NumberTrivia>>? getRandomNumberTrivia() async {
    return await _getTrivia(() => remoteDataSource.getRandomNumberTrivia());
  }

  Future<Either<Failure, NumberTrivia>> _getTrivia(
      _ConceretOrRandomNumberChooser _conceretOrRandomNumberChooser) async {
    try {
      if (await networkInfo.isConnected) {
        final numberTrive = await _conceretOrRandomNumberChooser();

        localDataSource.cacheNumberTriviaModal(numberTrive);

        return Right(numberTrive);
      } else {
        try {
          return Right(await localDataSource.getLastNumberTrivia());
        } on CacheException catch (_) {
          return Left(CacheFailure());
        }
      }
    } on ServerException catch (_) {
      return Left(ServerFailure());
    }
  }
}
