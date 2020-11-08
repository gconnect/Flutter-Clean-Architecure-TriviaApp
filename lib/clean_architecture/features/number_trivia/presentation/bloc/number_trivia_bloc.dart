import 'package:bloc/bloc.dart';
import 'package:cleanarchitecturetriviaapp/clean_architecture/core/error/failures.dart';
import 'package:cleanarchitecturetriviaapp/clean_architecture/core/usecase/usecase.dart';
import 'package:cleanarchitecturetriviaapp/clean_architecture/core/util/input_converter.dart';
import 'package:cleanarchitecturetriviaapp/clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:cleanarchitecturetriviaapp/clean_architecture/features/number_trivia/domain/usecase/get_concrete_number_trivia.dart';
import 'package:cleanarchitecturetriviaapp/clean_architecture/features/number_trivia/domain/usecase/get_random_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid input the number must be a valid integer or zero';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia concrete;
  final GetRandomNumberTrivia random;
  final InputConverter inputConverter;

  NumberTriviaBloc(
      {@required this.concrete,
      @required this.random,
      @required this.inputConverter})
      : assert(concrete != null),
        assert(random != null);

  @override
  Stream<NumberTriviaState> mapEventToState(
    NumberTriviaEvent event,
  ) async* {
    if (event is GetTriviaForConcreteNumber) {
      final inputEither =
          inputConverter.stringToUnsignedInteger(event.numberString);
      yield* inputEither.fold(
        (failure) async* {
          yield Error(message: INVALID_INPUT_FAILURE_MESSAGE);
        },
        (integer) async* {
          yield Loading();
          final failureOrTrivia = await concrete(Params(number: integer));
          yield* _eitherLoadedOrErrorState(failureOrTrivia);
        },
      );
    } else if (event is GetTriviaForRandomNumber) {
      yield Loading();
      final failureOrTrivia = await random(NoParams());
      yield* _eitherLoadedOrErrorState(failureOrTrivia);
    }
  }

  @override
  // TODO: implement initialState
  NumberTriviaState get initialState => throw UnimplementedError();

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected error';
    }
  }

  Stream<NumberTriviaState> _eitherLoadedOrErrorState(
      Either<Failure, NumberTrivia> failureOrTrivia) async* {
    yield failureOrTrivia.fold(
        (failure) => throw Error(message: _mapFailureToMessage(failure)),
        (trivia) => Loaded(trivia: trivia));
  }
}
