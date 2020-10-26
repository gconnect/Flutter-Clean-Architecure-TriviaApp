import 'package:cleanarchitecturetriviaapp/clean_architecture/core/error/failures.dart';
import 'package:dartz/dartz.dart';

class InputConverter {
  Either<Failure, int> stringToUnsignedInteger(String str) {
    try {
      final interger = int.parse(str);
      if (interger < 0) throw FormatException();
      return Right(interger);
    } on FormatException {
      Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}
