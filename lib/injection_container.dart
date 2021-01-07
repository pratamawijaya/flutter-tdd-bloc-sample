import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_clean_arch_tdd_bloc/core/network/network_info.dart';
import 'package:flutter_clean_arch_tdd_bloc/features/number_trivias/data/datasources/local/number_trivia_local_datasource.dart';
import 'package:flutter_clean_arch_tdd_bloc/features/number_trivias/data/datasources/remote/number_trivia_remote_datasource.dart';
import 'package:flutter_clean_arch_tdd_bloc/features/number_trivias/domain/usecases/get_random_number_trivia.dart';
import 'package:flutter_clean_arch_tdd_bloc/features/number_trivias/presentation/bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'features/number_trivias/data/repositories/number_trivia_repository_impl.dart';
import 'features/number_trivias/domain/repositories/number_trivia_repository.dart';
import 'features/number_trivias/domain/usecases/get_concrete_number_trivia.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // bloc
  sl.registerFactory(() => NumberTriviaBloc(concrete: sl(), random: sl()));

  // use case
  sl.registerLazySingleton(() => GetConcreteNumberTrivia(sl()));
  sl.registerLazySingleton(() => GetRandomNumberTrivia(sl()));

  // repository
  sl.registerLazySingleton<NumberTriviaRepository>(
      () => NumberTriviaRepositoryImpl(
            remoteDatasource: sl(),
            localDataSource: sl(),
            networkInfo: sl(),
          ));

  // data source
  sl.registerLazySingleton<NumberTriviaLocalDataSource>(
      () => NumberTriviaLocalDataSourceImpl(sharedPreferences: sl()));
  sl.registerLazySingleton<NumberTriviaRemoteDatasource>(
      () => NumberTriviaRemoteDatasourceImpl(sl()));

  // core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // external
  final sharedPref = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPref);
  sl.registerLazySingleton(() => http.Client);
  sl.registerLazySingleton(() => DataConnectionChecker());
}
