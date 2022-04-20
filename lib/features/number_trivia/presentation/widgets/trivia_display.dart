import 'package:flutter/material.dart';

import '../../domain/entities/number_trivia.dart';
import 'widget.dart';

class TriviaDisplay extends StatelessWidget {
  const TriviaDisplay({
    Key? key,
    required this.trivia,
  }) : super(key: key);
  final NumberTrivia trivia;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 3,
      child: Column(
        children: [
          Text(
            trivia.number.toString(),
            style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: MessageWidget(message: trivia.text),
              ),
            ),
          )
        ],
      ),
    );
  }
}
