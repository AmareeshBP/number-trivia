import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../bloc/number_trivia_bloc.dart';
import '../widgets/widgets.dart';

class NumberTriviaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Number Trivia'),
      ),
      body: SingleChildScrollView(child: buildBlocProvider(context)),
    );
  }

  BlocProvider<NumberTriviaBloc> buildBlocProvider(BuildContext context) {
    return BlocProvider(
      builder: (context) => sl<NumberTriviaBloc>(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              SizedBox(height: 10),
              // Top Half
              BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                builder: (context, state) {
                  if (state is Empty) {
                    return MessageDisplay(message: 'Start searching!');
                  } else if (state is Error) {
                    return MessageDisplay(message: state.message);
                  } else if (state is Loaded) {
                    return TriviaDisplay(trivia: state.numberTrivia);
                  } else if (state is Loading) {
                    return LoadingWidget();
                  }
                },
              ),
              SizedBox(height: 20),

              // Bottom Half
              TriviaControls()
            ],
          ),
        ),
      ),
    );
  }
}
