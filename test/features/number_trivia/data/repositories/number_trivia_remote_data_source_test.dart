import 'dart:convert';

import 'package:cleanarchitecturetriviaapp/clean_architecture/core/error/exceptions.dart';
import 'package:cleanarchitecturetriviaapp/clean_architecture/features/number_trivia/data/datasource/number_trivia_remote_datasource.dart';
import 'package:cleanarchitecturetriviaapp/clean_architecture/features/number_trivia/data/model/number_trivia_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  NumberTriviaRemoteDataSourceImpl datasource;
  MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    datasource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setUpMockHttpSucess200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setUpMockHttpFailure404() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  // ConcreteNumberTrivia
  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test(
        '''should perform a GET request in a URL with number being the endpoint'
        ' and with application/json header''', () async {
      // arrange
      setUpMockHttpSucess200();
      // act
      datasource.getConcreteNumberTrivia(tNumber);
      // assert
      verify(mockHttpClient.get('http://numbersapi.com/$tNumber', headers: {
        'content-Type': 'application/j      son',
      }));
    });

    test('should return NumberTrivia when the response code is 200 (success)',
        () async {
      // arrange
      setUpMockHttpSucess200();
      // act
      final result = await datasource.getConcreteNumberTrivia(tNumber);
      // assert
      expect(result, equals(tNumberTriviaModel));
    });

    test('should throw a ServerException when the response code is 404',
        () async {
      // arrange
      setUpMockHttpFailure404();
      //act
      final call = datasource.getConcreteNumberTrivia;
      //assert
      expect(() => call(tNumber), throwsA(TypeMatcher<ServerException>()));
    });
  });

  // RandomTrivia
  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test(
        '''should perform a GET request in a URL with number being the endpoint'
        ' and with application/json header''', () async {
      // arrange
      setUpMockHttpSucess200();
      // act
      datasource.getRandomNumberTrivia();
      // assert
      verify(mockHttpClient.get('http://numbersapi.com/random', headers: {
        'content-Type': 'application/j      son',
      }));
    });

    test('should return NumberTrivia when the response code is 200 (success)',
        () async {
      // arrange
      setUpMockHttpSucess200();
      // act
      final result = await datasource.getRandomNumberTrivia();
      // assert
      expect(result, equals(tNumberTriviaModel));
    });

    test('should throw a ServerException when the response code is 404',
        () async {
      // arrange
      setUpMockHttpFailure404();
      //act
      final call = datasource.getRandomNumberTrivia();
      //assert
      expect(() => call, throwsA(TypeMatcher<ServerException>()));
    });
  });
}
