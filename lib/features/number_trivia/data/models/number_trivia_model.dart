import '../../domain/entities/number_trivia.dart';

class NumberTriviaModal extends NumberTrivia {
  const NumberTriviaModal({required String text, required int number})
      : super(text: text, number: number);

  factory NumberTriviaModal.fromJson(Map<String, dynamic> json) =>
      NumberTriviaModal(
          text: json['text'], number: (json['number'] as num).toInt());

  Map<String, dynamic> toJson() => {'text': text, 'number': number};
}
