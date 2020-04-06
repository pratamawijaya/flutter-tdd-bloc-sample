import 'package:bloc/bloc.dart';
import 'package:flutter_clean_arch_tdd_bloc/features/number_trivias/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_clean_arch_tdd_bloc/features/number_trivias/domain/usecases/get_random_number_trivia.dart';
import 'package:flutter_clean_arch_tdd_bloc/features/number_trivias/presentation/bloc/number_trivia_event.dart';
import 'package:flutter_clean_arch_tdd_bloc/features/number_trivias/presentation/bloc/number_trivia_state.dart';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;

  NumberTriviaBloc(this.getConcreteNumberTrivia, this.getRandomNumberTrivia);

  @override
  NumberTriviaState get initialState => Empty();

  @override
  Stream<NumberTriviaState> mapEventToState(NumberTriviaEvent event) async* {
    if (event is GetTriviaForConcreteNumber) {
      String anu = event.numberString;
    }
    return null;
  }
}
