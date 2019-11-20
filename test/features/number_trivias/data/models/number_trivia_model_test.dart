import 'dart:convert';
import 'dart:io';

import 'package:flutter_clean_arch_tdd_bloc/features/number_trivias/data/models/number_trivia_model.dart';
import 'package:flutter_clean_arch_tdd_bloc/features/number_trivias/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final testNumberTriviaModel = NumberTriviaModel(number: 1, text: 'Test Text');

  test('should be subclass of NumberTrivia entity', () async {
    expect(testNumberTriviaModel, isA<NumberTrivia>());
  });

  group('from json', () {
    test('should return valid json when number is an integer', () async {
      final String jsonFile =
          await File(testPath('fixtures/trivia.json')).readAsString();

      final Map<String, dynamic> jsonMap = json.decode(jsonFile);

      final result = NumberTriviaModel.fromJson(jsonMap);

      expect(result, testNumberTriviaModel);
    });

    test('should return valid json when number is an double', () async {
      final String jsonFile =
          await File(testPath('fixtures/trivia_double.json')).readAsString();

      final Map<String, dynamic> jsonMap = json.decode(jsonFile);

      final result = NumberTriviaModel.fromJson(jsonMap);

      expect(result, testNumberTriviaModel);
    });
  });

  group('to json', () {
    test('should return a JSON map containing proper data', () async {
      final result = testNumberTriviaModel.toJson();

      final expectedMap = {
        "text": "Test Text",
        "number": 1,
      };

      expect(result, expectedMap);
    });
  });
}
