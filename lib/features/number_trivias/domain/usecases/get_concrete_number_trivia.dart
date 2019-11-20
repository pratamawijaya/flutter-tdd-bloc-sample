import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_clean_arch_tdd_bloc/core/error/Failure.dart';
import 'package:flutter_clean_arch_tdd_bloc/core/usecase/usecase.dart';
import 'package:flutter_clean_arch_tdd_bloc/features/number_trivias/domain/entities/number_trivia.dart';
import 'package:flutter_clean_arch_tdd_bloc/features/number_trivias/domain/repositories/number_trivia_repository.dart';

class GetConcreteNumberTrivia extends UseCase<NumberTrivia, Params> {
  final NumberTriviaRepository repository;

  GetConcreteNumberTrivia(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>> call(Params params) async {
    return await repository.getConcreteNumberTrivia(params.number);
  }
}

class Params extends Equatable {
  final int number;

  Params({@required this.number});

  @override
  List<Object> get props => [number];
}
