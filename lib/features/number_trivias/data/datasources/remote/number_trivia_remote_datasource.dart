import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import 'package:flutter_clean_arch_tdd_bloc/core/error/exception.dart';
import 'package:flutter_clean_arch_tdd_bloc/features/number_trivias/data/models/number_trivia_model.dart';

abstract class NumberTriviaRemoteDatasource {
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);

  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class NumberTriviaRemoteDatasourceImpl extends NumberTriviaRemoteDatasource {
  final http.Client client;

  NumberTriviaRemoteDatasourceImpl(this.client);

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) {
    return _getTriviaFromUrl("http://numbersapi.com/$number");
  }

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() {
    return _getTriviaFromUrl("http://numbersapi.com/random");
  }

  Future<NumberTriviaModel> _getTriviaFromUrl(String url) async {
    final response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return NumberTriviaModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
