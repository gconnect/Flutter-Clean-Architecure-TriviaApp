import 'package:cleanarchitecturetriviaapp/clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:cleanarchitecturetriviaapp/clean_architecture/features/number_trivia/domain/repositories/number_trivia_repositories.dart';
import 'package:cleanarchitecturetriviaapp/clean_architecture/features/number_trivia/domain/usecase/get_concrete_number_trivia.dart';
import 'package:cleanarchitecturetriviaapp/clean_architecture/features/number_trivia/domain/usecase/get_random_number_trivia.dart';
import 'package:cleanarchitecturetriviaapp/clean_architecture/features/number_trivia/domain/usecase/get_random_number_trivia.dart';
import 'package:cleanarchitecturetriviaapp/clean_architecture/features/number_trivia/domain/usecase/get_random_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:cleanarchitecturetriviaapp/clean_architecture/core/usecase/usecase.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  GetRandomNumberTrivia usecase;
  MockNumberTriviaRepository mockNumberTriviaRepository;
  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetRandomNumberTrivia(mockNumberTriviaRepository);
  });

  final tNumberTrivia = NumberTrivia(number: 1, text: 'text');

  test("should get number from the repository", () async {
    //arrange
    when(mockNumberTriviaRepository.getRandomNumberTrivia())
        .thenAnswer((_) async => Right(tNumberTrivia));

    //act
    final result = await usecase(NoParams());
    //assert
    expect(result, Right(tNumberTrivia));
    verify(mockNumberTriviaRepository.getRandomNumberTrivia());
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}
