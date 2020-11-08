import 'package:cleanarchitecturetriviaapp/clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter/material.dart';

class NumberTriviaDisplay extends StatelessWidget {
  final NumberTrivia numberTrivia;

  NumberTriviaDisplay({Key key, this.numberTrivia}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          numberTrivia.number.toString(),
          style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
        ),
        Center(
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height / 3,
              child: Text(
                numberTrivia.text,
                style: TextStyle(fontSize: 25.0),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
