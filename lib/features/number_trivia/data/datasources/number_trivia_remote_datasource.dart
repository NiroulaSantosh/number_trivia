import 'dart:convert';

import 'package:http/http.dart';
import 'package:number_trivia/core/errors/exceptions.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';

abstract class NumberTriviaRemoteDataSource {
  Future<NumberTriviaModal> getConcereteNumberTrivia(int number);
  Future<NumberTriviaModal> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl extends NumberTriviaRemoteDataSource {
  final Client client;

  NumberTriviaRemoteDataSourceImpl(this.client);
  @override
  Future<NumberTriviaModal> getConcereteNumberTrivia(int number) async {
    return _getNumberTrivia('$number');
  }

  @override
  Future<NumberTriviaModal> getRandomNumberTrivia() async {
    return await _getNumberTrivia('random');
  }

  Future<NumberTriviaModal> _getNumberTrivia(String path) async {
    final response = await client.get(
      Uri.parse('http://numbersapi.com/$path'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return NumberTriviaModal.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException();
    }
  }
}
