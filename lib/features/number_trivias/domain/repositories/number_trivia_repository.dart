import 'package:dartz/dartz.dart';
import 'package:flutter_clean_arch_tdd_bloc/core/error/Failure.dart';
import 'package:flutter_clean_arch_tdd_bloc/features/number_trivias/domain/entities/number_trivia.dart';

abstract class NumberTriviaRepository {
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia();

  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number);
}
