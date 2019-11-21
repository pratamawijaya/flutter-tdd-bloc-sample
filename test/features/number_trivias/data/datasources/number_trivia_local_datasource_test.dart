import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_clean_arch_tdd_bloc/core/error/exception.dart';
import 'package:flutter_clean_arch_tdd_bloc/features/number_trivias/data/datasources/local/number_trivia_local_datasource.dart';
import 'package:flutter_clean_arch_tdd_bloc/features/number_trivias/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPref extends Mock implements SharedPreferences {}

void main() {
  NumberTriviaLocalDataSourceImpl localDataSource;
  MockSharedPref mockSharedPref;

  setUp(() {
    mockSharedPref = MockSharedPref();
    localDataSource =
        NumberTriviaLocalDataSourceImpl(sharedPreferences: mockSharedPref);
  });

  group('get last number trivia', () {
    test(
        'should return NumberTrivia from shared pref when there is one in the cache',
        () async {
      final String jsonFile =
          await File(testPath('fixtures/trivia_cached.json')).readAsString();
      final Map<String, dynamic> jsonMap = json.decode(jsonFile);
      final tNumberTriviaModel = NumberTriviaModel.fromJson(jsonMap);

      when(mockSharedPref.getString(any)).thenReturn(jsonFile);

      final result = await localDataSource.getLastNumberTrivia();

      verify(mockSharedPref.getString('CACHED_NUMBER_TRIVIA'));
      expect(result, equals(tNumberTriviaModel));
    });
  });
}
