import 'package:dartz/dartz.dart';
import 'package:flutter_clean_arch_tdd_bloc/core/usecase/usecase.dart';
import 'package:flutter_clean_arch_tdd_bloc/features/number_trivias/domain/entities/number_trivia.dart';
import 'package:flutter_clean_arch_tdd_bloc/features/number_trivias/domain/repositories/number_trivia_repository.dart';
import 'package:flutter_clean_arch_tdd_bloc/features/number_trivias/domain/usecases/get_random_number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  GetRandomNumberTrivia useCase;
  MockNumberTriviaRepository mockNumberTriviaRepository;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    useCase = GetRandomNumberTrivia(mockNumberTriviaRepository);
  });

  final testNumberTrivia = NumberTrivia(number: 1, text: 'test');

  test('should get trivia from the repository', () async {
    when(mockNumberTriviaRepository.getRandomNumberTrivia())
        .thenAnswer((_) async => Right(testNumberTrivia));

    final result = await useCase(NoParams());

    expect(result, Right(testNumberTrivia));

    verify(mockNumberTriviaRepository.getRandomNumberTrivia());
    verifyNoMoreInteractions((mockNumberTriviaRepository));
  });
}
