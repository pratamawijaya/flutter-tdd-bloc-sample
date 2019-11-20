import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_clean_arch_tdd_bloc/core/error/Failure.dart';
import 'package:flutter_clean_arch_tdd_bloc/core/error/exception.dart';
import 'package:flutter_clean_arch_tdd_bloc/core/platform/network_info.dart';
import 'package:flutter_clean_arch_tdd_bloc/features/number_trivias/data/datasources/local/number_trivia_local_datasource.dart';
import 'package:flutter_clean_arch_tdd_bloc/features/number_trivias/data/datasources/remote/number_trivia_remote_datasource.dart';
import 'package:flutter_clean_arch_tdd_bloc/features/number_trivias/domain/entities/number_trivia.dart';
import 'package:flutter_clean_arch_tdd_bloc/features/number_trivias/domain/repositories/number_trivia_repository.dart';

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaRemoteDatasource remoteDatasource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl(
      {@required this.remoteDatasource,
      @required this.localDataSource,
      @required this.networkInfo});

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
      int number) async {
    networkInfo.isConnected;
    if (await networkInfo.isConnected) {
      try {
        final remoteTrivia =
            await remoteDatasource.getConcreteNumberTrivia(number);
        localDataSource.cachedNumberTrivia(remoteTrivia);
        return Right(remoteTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      final localTrivia = await localDataSource.getLastNumberTrivia();
      return Right(localTrivia);
    }
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() {
    // TODO: implement getRandomNumberTrivia
    return null;
  }
}
