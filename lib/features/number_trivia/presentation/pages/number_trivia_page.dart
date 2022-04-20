import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../bloc/number_trivia/number_trivia_bloc.dart';
import '../widgets/widget.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Number Trivia'),
      ),
      body: body(),
    );
  }

  BlocProvider<NumberTriviaBloc> body() {
    return BlocProvider<NumberTriviaBloc>(
      create: (context) => sl<NumberTriviaBloc>(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const SizedBox(height: 10),
              BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                  builder: (context, state) {
                if (state is Empty) {
                  return const MessageWidget(
                    message: 'Start Searching',
                  );
                } else if (state is Loading) {
                  return const LoadingWidget();
                } else if (state is Loaded) {
                  return TriviaDisplay(trivia: state.trivia);
                } else if (state is Error) {
                  return MessageWidget(message: state.message);
                } else {
                  return const SizedBox();
                }
              }),
              const SizedBox(height: 10),
              const TriviaControls(),
            ],
          ),
        ),
      ),
    );
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 3,
      child: const Center(
        child: CircularProgressIndicator.adaptive(),
      ),
    );
  }
}
