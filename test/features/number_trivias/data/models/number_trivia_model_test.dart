import 'package:flutter_clean_arch_tdd_bloc/features/number_trivias/data/models/number_trivia_model.dart';
import 'package:flutter_clean_arch_tdd_bloc/features/number_trivias/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final testNumberTriviaModel = NumberTriviaModel(number: 1, text: 'test');

  test('should be a subclass NumberTrivia entity', () async {
    expect(testNumberTriviaModel, isA<NumberTrivia>());
  });
}
