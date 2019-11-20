import 'package:flutter_clean_arch_tdd_bloc/features/number_trivias/data/models/number_trivia_model.dart';

abstract class NumberTriviaLocalDataSource {
  Future<NumberTriviaModel> getLastNumberTrivia();

  Future<void> cachedNumberTrivia(NumberTriviaModel triviaToCache);
}
