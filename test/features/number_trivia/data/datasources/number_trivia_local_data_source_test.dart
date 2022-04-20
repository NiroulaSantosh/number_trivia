import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/errors/exceptions.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'number_trivia_local_data_source_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  late MockSharedPreferences mockSharedPreferences;
  late NumberTriviaLocalDataSourceImpl localDataSourceImpl;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    localDataSourceImpl =
        NumberTriviaLocalDataSourceImpl(mockSharedPreferences);
  });

  group('getLatestNumberTrivia', () {
    final triviaModal =
        NumberTriviaModal.fromJson(jsonDecode(fixture('trivia_cached.json')));

    test(
        'should return data from sharedPreferences when there is is one in cache',
        () async {
      when(mockSharedPreferences.getString(any))
          .thenReturn(fixture('trivia_cached.json'));

      final result = await localDataSourceImpl.getLastNumberTrivia();

      verify(mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA));
      expect(result, triviaModal);
    });

    test('should return cachedexception when there is no data', () async {
      when(mockSharedPreferences.getString(any)).thenReturn(null);

      final call = localDataSourceImpl.getLastNumberTrivia;

      expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
    });
  });

  group('cacheNumberTrivia', () {
    const triviaModel = NumberTriviaModal(text: 'test trivia', number: 1);

    test('should add data to shared preference', () {
      when(mockSharedPreferences.setString(any, any))
          .thenAnswer((realInvocation) async => Future.value(true));

      localDataSourceImpl.cacheNumberTriviaModal(triviaModel);

      verify(mockSharedPreferences.setString(
          CACHED_NUMBER_TRIVIA, json.encode(triviaModel.toJson())));
    });
  });
}
