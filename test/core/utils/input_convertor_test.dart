import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/core/util/input_convertor.dart';

void main() {
  late InputConvertor inputConvertor;

  setUp(() {
    inputConvertor = InputConvertor();
  });

  group('stringToUnsignedInt', () {
    test('should return int when string represent unsigned int', () {
      const str = '123';
      final result = inputConvertor.stringtoUnsingedInteger(str);
      expect(result, equals(const Right(123)));
    });

    test('should return invalid input failure', () {
      const str = 'abc';
      final result = inputConvertor.stringtoUnsingedInteger(str);
      expect(result, equals(Left(InvalidInputFailure())));
    });

    test('should return invalidinput failure when input is negative', () {
      const str = '-123';
      final result = inputConvertor.stringtoUnsingedInteger(str);

      expect(result, equals(Left(InvalidInputFailure())));
    });
  });
}
