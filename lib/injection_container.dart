import 'core/network/network_info.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'Features/number_trivia/Data/datasources/number_trivia_local_datasource.dart';
import 'Features/number_trivia/Data/datasources/number_trivia_remote_datasource.dart';
import 'Features/number_trivia/Data/repositories/number_trivia_repository_impl.dart';
import 'Features/number_trivia/Domain/Repository/number_trivia_repository.dart';
import 'Features/number_trivia/Domain/Usecases/get_concrete_number_trivia.dart';
import 'Features/number_trivia/Domain/Usecases/get_random_number_trivia.dart';
import 'Features/number_trivia/Presentation/bloc/number_trivia_bloc.dart';
import 'core/utils/input_converter.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Freatures - Number Trivia
   
  sl.registerFactory(
    () => NumberTriviaBloc(
      concrete: sl(),
      random: sl(),
      inputConverter: sl(),
    ),
  );
  // Data sources
  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
    () => NumberTriviaRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton<NumberTriviaLocalDataSource>(
    () => NumberTriviaLocalDataSourceImpl(sharedPreferences: sl()),
  );
// Repository
  sl.registerLazySingleton<NumberTriviaRepository>(
    () => NumberTriviaRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );
// Use cases
  sl.registerLazySingleton<GetConcreteNumberTrivia>(
      () => GetConcreteNumberTrivia(sl()));
  sl.registerLazySingleton<GetRandomNumberTrivia>(
      () => GetRandomNumberTrivia(sl()));

  //! Core
   sl.registerLazySingleton<InputConverter>(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton<http.Client>(() => http.Client());
  sl.registerLazySingleton<InternetConnectionChecker>(
      () => InternetConnectionChecker());
}
