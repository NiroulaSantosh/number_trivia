import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tNumberTriviaModel = NumberTriviaModal(text: 'Test Text', number: 1);

  test('should be a subclass of number trivia', () {
    expect(tNumberTriviaModel, isA<NumberTrivia>());
  });

  group('fromJson', () {
    test('should return valid model when  the JSON  is an integer', () {
      final json = jsonDecode(fixture('trivia_double.json'));
      final convetredData = NumberTriviaModal.fromJson(json);
      expect(convetredData, tNumberTriviaModel);
    });
  });

  group('toJson', () {
    test('should return proper Map data', () {
      final mappedData = tNumberTriviaModel.toJson();

      expect(mappedData, {'text': 'Test Text', 'number': 1});
    });
  });
}
