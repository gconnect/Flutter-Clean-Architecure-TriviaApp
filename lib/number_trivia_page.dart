import 'package:cleanarchitecturetriviaapp/clean_architecture/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:cleanarchitecturetriviaapp/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'clean_architecture/features/number_trivia/presentation/widgets/loading_widget.dart';
import 'clean_architecture/features/number_trivia/presentation/widgets/message_display.dart';
import 'clean_architecture/features/number_trivia/presentation/widgets/trivia_controls.dart';
import 'clean_architecture/features/number_trivia/presentation/widgets/trivia_display.dart';

class NumberTriviaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Number Trivia"),
      ),
      body: SingleChildScrollView(child: buildBody(context)),
    );
  }

  BlocProvider<NumberTriviaBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<NumberTriviaBloc>(),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              SizedBox(
                height: 10.0,
              ),
              BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                builder: (context, state) {
                  return checkState(context, state);
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              SizedBox(
                height: 20.0,
              ),
              TriviaControls()
            ],
          ),
        ),
      ),
    );
  }
}

checkState(BuildContext, state) {
  if (state is Empty) {
    return MessageDisplay(
      message: "Start Searching..",
    );
  } else if (state is Loaded) {
    return NumberTriviaDisplay(
      numberTrivia: state.trivia,
    );
  } else if (state is Loading) {
    return LoadingWidget();
  } else if (state is Error) {
    return MessageDisplay(message: state.message);
  }
}
