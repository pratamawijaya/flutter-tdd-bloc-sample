import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_arch_tdd_bloc/core/error/Failure.dart';
import 'package:flutter_clean_arch_tdd_bloc/core/usecase/usecase.dart';
import 'package:flutter_clean_arch_tdd_bloc/features/number_trivias/domain/entities/number_trivia.dart';
import 'package:flutter_clean_arch_tdd_bloc/features/number_trivias/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_clean_arch_tdd_bloc/features/number_trivias/domain/usecases/get_random_number_trivia.dart';
import 'package:flutter_clean_arch_tdd_bloc/features/number_trivias/presentation/bloc/number_trivia_event.dart';
import 'package:flutter_clean_arch_tdd_bloc/features/number_trivias/presentation/bloc/number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a positive integer or zero.';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;

  NumberTriviaBloc({
    @required GetConcreteNumberTrivia concrete,
    @required GetRandomNumberTrivia random,
  })  : assert(concrete != null),
        assert(random != null),
        getConcreteNumberTrivia = concrete,
        getRandomNumberTrivia = random;

  @override
  NumberTriviaState get initialState => Empty();

  @override
  Stream<NumberTriviaState> mapEventToState(NumberTriviaEvent event) async* {
    if (event is GetTriviaForConcreteNumber) {
      final inputan = event.numberString;

      yield Loading();

      final failureOrTriva =
          await getConcreteNumberTrivia(Params(number: int.parse(inputan)));
      yield* _eitherLoadedOrErrorState(failureOrTriva);

    } else if (event is GetRandomNumberTrivia) {
      yield Loading();
      final failureOrTrivia = await getRandomNumberTrivia(NoParams());
      yield* _eitherLoadedOrErrorState(failureOrTrivia);
    }
  }

  Stream<NumberTriviaState> _eitherLoadedOrErrorState(
    Either<Failure, NumberTrivia> failureOrTrivia,
  ) async* {
    yield failureOrTrivia.fold(
      (failure) => Error(message: _mapFailureToMessage(failure)),
      (trivia) => Loaded(trivia: trivia),
    );
  }

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
}
