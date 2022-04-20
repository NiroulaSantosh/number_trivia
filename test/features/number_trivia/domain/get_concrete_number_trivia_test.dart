import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';

import 'get_concrete_number_trivia_test.mocks.dart';

@GenerateMocks([NumberTriviaRepository])
void main() {
  late GetConcreteNumberTrivia usecases;
  late MockNumberTriviaRepository mockNumberTriviaRepository;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecases = GetConcreteNumberTrivia(mockNumberTriviaRepository);
  });
  const tNumber = 1;
  const tNumberTrivia = NumberTrivia(text: 'test', number: tNumber);

  test('should get trivia for number form repository', () async {
    when(mockNumberTriviaRepository.getConceretNumberTrivia(tNumber))
        .thenAnswer((realInvocation) async => const Right(tNumberTrivia));

    final result = await usecases(const Params(number: tNumber));

    expect(result, const Right(tNumberTrivia));

    verify(mockNumberTriviaRepository.getConceretNumberTrivia(tNumber));

    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}
