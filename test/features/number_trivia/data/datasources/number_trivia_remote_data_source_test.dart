import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/errors/exceptions.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'number_trivia_remote_data_source_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late MockClient mockClient;
  late NumberTriviaRemoteDataSourceImpl dataSource;

  setUp(() {
    mockClient = MockClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(mockClient);
  });

  void setUpMockHttpClientSuccess200() {
    when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer(
      (_) async => http.Response(fixture('trivia.json'), 200),
    );
  }

  void setUpMockHttpClientFailure404() {
    when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer(
      (_) async => http.Response('Something went wrong', 404),
    );
  }

  group('getConceretNumberTrivia', () {
    const tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModal.fromJson(json.decode(fixture('trivia.json')));

    test('should perform GET request on the provided endpoint', () async {
      setUpMockHttpClientSuccess200();

      dataSource.getConcereteNumberTrivia(tNumber);

      verify(mockClient.get(
        Uri.tryParse('http://numbersapi.com/$tNumber'),
        headers: {'Content-Type': 'application/json'},
      ));
    });

    test('should return proper data when status code is 200 (success)',
        () async {
      setUpMockHttpClientSuccess200();
      final data = await dataSource.getConcereteNumberTrivia(tNumber);
      expect(data, equals(tNumberTriviaModel));
    });
    test('should throw ServerException when status code is 4xx or 5xx',
        () async {
      setUpMockHttpClientFailure404();

      final call = dataSource.getConcereteNumberTrivia;

      expect(
          () => call(tNumber), throwsA(const TypeMatcher<ServerException>()));
    });
  });

  group('getRandomNumberTrivia', () {
    const tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModal.fromJson(json.decode(fixture('trivia.json')));

    test('should perform GET request on the provided endpoint', () async {
      setUpMockHttpClientSuccess200();

      dataSource.getRandomNumberTrivia();

      verify(mockClient.get(
        Uri.tryParse('http://numbersapi.com/random'),
        headers: {'Content-Type': 'application/json'},
      ));
    });

    test('should return proper data when status code is 200 (success)',
        () async {
      setUpMockHttpClientSuccess200();
      final data = await dataSource.getConcereteNumberTrivia(tNumber);
      expect(data, equals(tNumberTriviaModel));
    });
    test('should throw ServerException when status code is 4xx or 5xx',
        () async {
      setUpMockHttpClientFailure404();

      final call = dataSource.getConcereteNumberTrivia;

      expect(
          () => call(tNumber), throwsA(const TypeMatcher<ServerException>()));
    });
  });
}
