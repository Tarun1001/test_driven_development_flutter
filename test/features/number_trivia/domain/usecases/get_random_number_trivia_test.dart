import 'package:app1/Features/number_trivia/Domain/Entities/number_trivia.dart';
import 'package:app1/Features/number_trivia/Domain/Repository/number_trivia_repository.dart';
import 'package:app1/Features/number_trivia/Domain/Usecases/get_random_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';



class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {} 
 void main() {
  GetRandomNumberTrivia usecase;
  MockNumberTriviaRepository mockNumberTriviaRepository;

  mockNumberTriviaRepository = MockNumberTriviaRepository();
  usecase = GetRandomNumberTrivia(repository:  mockNumberTriviaRepository);

  
  final tNubmerTrivia = NumberTrivia(number: 1, text: 'test');

  test(
    'should get trivia  from the repository',
    () async {
      when(() => mockNumberTriviaRepository.getRandomNumberTrivia())
          .thenAnswer((_) async => Right(tNubmerTrivia));
      final result = await usecase(NoParams());

      expect(result, Right(tNubmerTrivia));

      verify(() => mockNumberTriviaRepository.getRandomNumberTrivia());

      verifyNoMoreInteractions(mockNumberTriviaRepository);
    },
  );
}
