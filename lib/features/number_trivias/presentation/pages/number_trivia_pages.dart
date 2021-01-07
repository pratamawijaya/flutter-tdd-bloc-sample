import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_arch_tdd_bloc/features/number_trivias/presentation/bloc/bloc.dart';
import 'package:flutter_clean_arch_tdd_bloc/features/number_trivias/presentation/widgets/MessageDisplay.dart';
import 'package:flutter_clean_arch_tdd_bloc/features/number_trivias/presentation/widgets/loading_widget.dart';
import 'package:flutter_clean_arch_tdd_bloc/features/number_trivias/presentation/widgets/trivia_display.dart';

import '../../../../injection_container.dart';

class NumberTriviaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  BlocProvider<NumberTriviaBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NumberTriviaBloc>(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                builder: (context, state) {
                  if (state is Empty) {
                    return MessageDisplay("Start Search");
                  } else if (state is Loaded) {
                    return TriviaDisplay(numberTrivia: state.trivia);
                  } else if (state is Loading) {
                    return LoadingWidget();
                  } else {
                    return Text("hello");
                  }
                },
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
