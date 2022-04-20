// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:number_trivia/core/errors/exceptions.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String CACHED_NUMBER_TRIVIA = 'CACHED_NUMBER_TRIVIA';

abstract class NumberTriviaLocalDataSource {
  Future<NumberTriviaModal> getLastNumberTrivia();

  Future<void> cacheNumberTriviaModal(NumberTriviaModal triviaToCache);
}

class NumberTriviaLocalDataSourceImpl extends NumberTriviaLocalDataSource {
  NumberTriviaLocalDataSourceImpl(this.sharedPreferences);

  final SharedPreferences sharedPreferences;
  @override
  Future<void> cacheNumberTriviaModal(NumberTriviaModal triviaToCache) async {
    sharedPreferences.setString(
        CACHED_NUMBER_TRIVIA, jsonEncode(triviaToCache.toJson()));
  }

  @override
  Future<NumberTriviaModal> getLastNumberTrivia() {
    final jsonString = sharedPreferences.getString(CACHED_NUMBER_TRIVIA);
    if (jsonString != null) {
      return Future.value(NumberTriviaModal.fromJson(jsonDecode(jsonString)));
    } else {
      throw CacheException();
    }
  }
}
