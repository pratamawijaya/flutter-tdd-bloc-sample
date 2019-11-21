import 'package:dartz/dartz.dart';
import 'package:flutter_clean_arch_tdd_bloc/core/error/Failure.dart';
import 'package:flutter_clean_arch_tdd_bloc/core/error/exception.dart';
import 'package:flutter_clean_arch_tdd_bloc/core/platform/network_info.dart';
import 'package:flutter_clean_arch_tdd_bloc/features/number_trivias/data/datasources/local/number_trivia_local_datasource.dart';
import 'package:flutter_clean_arch_tdd_bloc/features/number_trivias/data/datasources/remote/number_trivia_remote_datasource.dart';
import 'package:flutter_clean_arch_tdd_bloc/features/number_trivias/data/models/number_trivia_model.dart';
import 'package:flutter_clean_arch_tdd_bloc/features/number_trivias/data/repositories/number_trivia_repository_impl.dart';
import 'package:flutter_clean_arch_tdd_bloc/features/number_trivias/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/mockito.dart' as prefix0;

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDatasource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  NumberTriviaRepositoryImpl repository;
  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();

    repository = NumberTriviaRepositoryImpl(
        remoteDatasource: mockRemoteDataSource,
        localDataSource: mockLocalDataSource,
        networkInfo: mockNetworkInfo);
  });

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestsOffline(Function body) {
    group('devise is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }

  group('get concrete number', () {
    final tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel(number: tNumber, text: 'test trivia');
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test('should check if device is online', () {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      repository.getConcreteNumberTrivia(tNumber);

      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test(
          'should return remote data when the call remote data source is successfull',
          () async {
        when(mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
            .thenAnswer((_) async => tNumberTriviaModel);

        final result = await repository.getConcreteNumberTrivia(tNumber);

        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        expect(result, equals(Right(tNumberTrivia)));
      });

      test(
          'should cache the data locally when the call remote data source is successfull',
          () async {
        when(mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
            .thenAnswer((_) async => tNumberTriviaModel);

        await repository.getConcreteNumberTrivia(tNumber);

        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verify(mockLocalDataSource.cachedNumberTrivia(tNumberTrivia));
      });

      test(
          'should return server failure when call to remote source is unsuccess',
          () async {
        when(mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
            .thenThrow(ServerException());

        final result = await repository.getConcreteNumberTrivia(tNumber);

        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    runTestsOffline(() {
      test(
          'should return last locally cached data when the cached data is present',
          () async {
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTrivia);

        final result = await repository.getConcreteNumberTrivia(tNumber);

        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(Right(tNumberTrivia)));
      });

      test('should return CacheFailure when no cached data present', () async {
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenThrow(CacheException());

        final result = await repository.getConcreteNumberTrivia(tNumber);

        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });

  group('get random number', () {
    final testNumberTriviaModel =
        NumberTriviaModel(number: 124, text: 'Test trivia');
    final NumberTrivia testNumberTrivia = testNumberTriviaModel;

    test('should check if device is online', () {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      repository.getRandomNumberTrivia();

      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test('should return remote data when remote data call is success',
          () async {
        when(mockRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => testNumberTriviaModel);

        final result = await repository.getRandomNumberTrivia();

        verify(mockRemoteDataSource.getRandomNumberTrivia());

        expect(result, equals(Right(testNumberTrivia)));
      });

      test('should cache data when call remote data source is success',
          () async {
        when(mockRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => testNumberTriviaModel);

        await repository.getRandomNumberTrivia();

        verify(mockRemoteDataSource.getRandomNumberTrivia());
        verify(mockLocalDataSource.cachedNumberTrivia(testNumberTrivia));
      });

      test('should return server exception when remote data source is failed',
          () async {
        when(mockRemoteDataSource.getRandomNumberTrivia())
            .thenThrow(ServerException());

        final result = await repository.getRandomNumberTrivia();

        verify(mockRemoteDataSource.getRandomNumberTrivia());
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    runTestsOffline(() {
      test('should return last locally when cached data is present', () async {
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => testNumberTriviaModel);

        final result = await repository.getRandomNumberTrivia();

        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(Right(testNumberTrivia)));
      });

      test('should return cache failure when cached data not present',
          () async {
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenThrow(CacheException());

        final result = await repository.getRandomNumberTrivia();

        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });
}
