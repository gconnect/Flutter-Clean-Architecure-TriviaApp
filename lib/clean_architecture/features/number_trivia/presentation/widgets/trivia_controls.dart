import 'package:cleanarchitecturetriviaapp/clean_architecture/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TriviaControls extends StatefulWidget {
  @override
  _TriviaControlsState createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<TriviaControls> {
  String inputStr;

  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _controller,
          onSubmitted: (_) => dispatchConcrete(context),
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Input a number",
          ),
          onChanged: (value) {
            inputStr = value;
          },
        ),
        SizedBox(
          height: 10.0,
        ),
        Row(children: [
          Expanded(
              child: RaisedButton(
                  child: Text('Search'),
                  color: Theme.of(context).accentColor,
                  textTheme: ButtonTextTheme.primary,
                  onPressed: () {
                    dispatchConcrete(context);
                  })),
          SizedBox(
            width: 10.0,
          ),
          Expanded(
            child: RaisedButton(
              child: Text('Get Random Trivia'),
              onPressed: () {
                dispatchRandom(context);
              },
            ),
          )
        ])
      ],
    );
  }

  dispatchConcrete(BuildContext context) {
    _controller.clear();
    BlocProvider.of<NumberTriviaBloc>(context)
        .add(GetTriviaForConcreteNumber(inputStr));
  }

  dispatchRandom(BuildContext context) {
    _controller.clear();
    BlocProvider.of<NumberTriviaBloc>(context).add(GetTriviaForRandomNumber());
  }
}
