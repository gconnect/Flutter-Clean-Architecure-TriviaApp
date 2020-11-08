import 'package:cleanarchitecturetriviaapp/clean_architecture/core/network/network_info.dart';
import 'package:cleanarchitecturetriviaapp/clean_architecture/core/util/input_converter.dart';
import 'package:cleanarchitecturetriviaapp/clean_architecture/features/number_trivia/data/datasource/number_trivia_local_datasource.dart';
import 'package:cleanarchitecturetriviaapp/clean_architecture/features/number_trivia/data/datasource/number_trivia_remote_datasource.dart';
import 'package:cleanarchitecturetriviaapp/clean_architecture/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:cleanarchitecturetriviaapp/clean_architecture/features/number_trivia/domain/repositories/number_trivia_repositories.dart';
import 'package:cleanarchitecturetriviaapp/clean_architecture/features/number_trivia/domain/usecase/get_concrete_number_trivia.dart';
import 'package:cleanarchitecturetriviaapp/clean_architecture/features/number_trivia/domain/usecase/get_random_number_trivia.dart';
import 'package:cleanarchitecturetriviaapp/clean_architecture/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final serviceLocator = GetIt.instance;

void init() async {
  // Bloc
  serviceLocator.registerFactory(() => NumberTriviaBloc(
      concrete: serviceLocator(),
      random: serviceLocator(),
      inputConverter: serviceLocator()));
  // Usecases
  serviceLocator
      .registerLazySingleton(() => GetConcreteNumberTrivia(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => GetRandomNumberTrivia(serviceLocator()));

  // repository
  serviceLocator.registerLazySingleton<NumberTriviaRepository>(() =>
      NumberTriviaRepositoryImpl(
          remoteDataSource: serviceLocator(),
          localDataSource: serviceLocator(),
          networkInfo: serviceLocator()));

  // data sources
  serviceLocator.registerLazySingleton<NumberTriviaRemoteDataSource>(
      () => NumberTriviaRemoteDataSourceImpl(client: serviceLocator()));
  serviceLocator.registerLazySingleton<NumberTriviaLocalDataSource>(() =>
      NumberTriviaLocalDataSourceImpl(sharedPreferences: serviceLocator()));

  // core
  serviceLocator.registerLazySingleton(() => InputConverter());
  serviceLocator.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(serviceLocator()));

  //External
  final sharedPreferences = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton(() => sharedPreferences);
  serviceLocator.registerLazySingleton(() => http.Client());
  serviceLocator.registerLazySingleton(() => DataConnectionChecker());
}
