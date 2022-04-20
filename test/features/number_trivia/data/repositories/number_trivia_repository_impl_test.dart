import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/errors/exceptions.dart';
import 'package:number_trivia/core/errors/failures.dart';
import 'package:number_trivia/core/platform/network_info.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';

import 'number_trivia_repository_impl_test.mocks.dart';

@GenerateMocks(
    [NumberTriviaLocalDataSource, NumberTriviaRemoteDataSource, NetworkInfo])
void main() {
  late MockNumberTriviaLocalDataSource mockLocalDataSource;
  late MockNumberTriviaRemoteDataSource mockRemoteDataSource;
  late NumberTriviaRepositoryImpl repository;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockNetworkInfo = MockNetworkInfo();
    mockLocalDataSource = MockNumberTriviaLocalDataSource();
    mockRemoteDataSource = MockNumberTriviaRemoteDataSource();
    repository = NumberTriviaRepositoryImpl(
        localDataSource: mockLocalDataSource,
        remoteDataSource: mockRemoteDataSource,
        networkInfo: mockNetworkInfo);
  });

  void runTestOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected)
            .thenAnswer((realInvocation) async => true);
      });
      body();
    });
  }

  void runTestOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected)
            .thenAnswer((realInvocation) async => false);
      });

      body();
    });
  }

  group('getConceretNumberTrivia', () {
    const tNumber = 1;
    const tNumberTriviaModal =
        NumberTriviaModal(text: 'test trivia', number: tNumber);
    const NumberTrivia tNumberTrivia = tNumberTriviaModal;

    test('should check if the device is online ', () {
      when(mockNetworkInfo.isConnected)
          .thenAnswer((realInvocation) async => true);

      when(mockRemoteDataSource.getConcereteNumberTrivia(tNumber))
          .thenAnswer((realInvocation) async => tNumberTriviaModal);

      repository.getConceretNumberTrivia(tNumber);

      verify(mockNetworkInfo.isConnected);
    });

    runTestOnline(() {
      test(
          'should return remote data when call to remote data source is success',
          () async {
        when(mockRemoteDataSource.getConcereteNumberTrivia(tNumber))
            .thenAnswer((realInvocation) async => tNumberTriviaModal);

        final result = await repository.getConceretNumberTrivia(tNumber);

        verify(mockRemoteDataSource.getConcereteNumberTrivia(tNumber));
        expect(result, equals(const Right(tNumberTrivia)));
      });

      test('should cache the data locally when the call to remote is',
          () async {
        when(mockRemoteDataSource.getConcereteNumberTrivia(tNumber))
            .thenAnswer((realInvocation) async => tNumberTriviaModal);

        await repository.getConceretNumberTrivia(tNumber);

        verify(mockRemoteDataSource.getConcereteNumberTrivia(tNumber));
        verify(mockLocalDataSource.cacheNumberTriviaModal(tNumberTriviaModal));
      });

      test(
          'should return serverfaiure when the remote data get is unsucessfull',
          () async {
        when(mockRemoteDataSource.getConcereteNumberTrivia(tNumber))
            .thenThrow(ServerException());

        final result = await repository.getConceretNumberTrivia(tNumber);

        verify(mockRemoteDataSource.getConcereteNumberTrivia(tNumber));
        verifyZeroInteractions(mockLocalDataSource);

        expect(result, equals(Left(ServerFailure())));
      });
    });

    runTestOffline(() {
      test(
          'should return last locally cached data when the cached data is present',
          () async {
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenAnswer((realInvocation) async => tNumberTriviaModal);

        final result = await repository.getConceretNumberTrivia(tNumber);

        verifyZeroInteractions(mockRemoteDataSource);

        verify(mockLocalDataSource.getLastNumberTrivia());

        expect(result, equals(const Right(tNumberTrivia)));
      });

      test(
          'should return CacheFailure when failed to get data from local cache',
          () async {
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenThrow(CacheException());

        final result = await repository.getConceretNumberTrivia(tNumber);

        verify(mockLocalDataSource.getLastNumberTrivia());

        expect(result, equals(Left(CacheFailure())));
      });
    });
  });

  group('getRandomNumberTrivia', () {
    const tNumber = 1;
    const tNumberTriviaModal =
        NumberTriviaModal(text: 'test trivia', number: tNumber);
    const NumberTrivia tNumberTrivia = tNumberTriviaModal;

    test('should check if device is online', () async {
      when(mockNetworkInfo.isConnected)
          .thenAnswer((realInvocation) async => true);

      when(mockRemoteDataSource.getRandomNumberTrivia())
          .thenAnswer((realInvocation) async => tNumberTriviaModal);

      await repository.getRandomNumberTrivia();
      verify(mockNetworkInfo.isConnected);
    });

    runTestOnline(() {
      test('should return remote data when remote data call is success',
          () async {
        when(mockRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((realInvocation) async => tNumberTriviaModal);

        final result = await repository.getRandomNumberTrivia();
        verify(mockRemoteDataSource.getRandomNumberTrivia());
        expect(result, equals(const Right(tNumberTrivia)));
      });

      test(
          'should cache data locally when the remote data fetch is successfull',
          () async {
        when(mockRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((realInvocation) async => tNumberTriviaModal);

        final result = await repository.getRandomNumberTrivia();
        verify(mockRemoteDataSource.getRandomNumberTrivia());
        verify(mockLocalDataSource.cacheNumberTriviaModal(tNumberTriviaModal));
        expect(result, equals(const Right(tNumberTrivia)));
      });

      test('should return server failure when remote fetch failure', () async {
        when(mockRemoteDataSource.getRandomNumberTrivia())
            .thenThrow(ServerException());

        final result = await repository.getRandomNumberTrivia();

        verify(mockRemoteDataSource.getRandomNumberTrivia());

        expect(result, equals(Left(ServerFailure())));
      });
    });

    runTestOffline(() {
      test('should get data from local cache', () async {
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenAnswer((realInvocation) async => tNumberTriviaModal);

        final result = await repository.getRandomNumberTrivia();
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(const Right(tNumberTrivia)));
      });

      test(
          'should return CacheFailure on failling to get data from local cache',
          () async {
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenThrow(ServerException());

        final result = await repository.getRandomNumberTrivia();

        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(Left(ServerFailure())));
      });
    });
  });
}
