import 'package:app1/Features/number_trivia/Domain/Entities/number_trivia.dart';
import 'package:app1/Features/number_trivia/Domain/Repository/number_trivia_repository.dart';
import 'package:app1/Features/number_trivia/Domain/Usecases/get_concrete_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';



class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {} 
 void main() {
  GetConcreteNumberTrivia usecase;
  MockNumberTriviaRepository mockNumberTriviaRepository;

  mockNumberTriviaRepository = MockNumberTriviaRepository();
  usecase = GetConcreteNumberTrivia(mockNumberTriviaRepository);

  final tNumber = 1;
  final tNubmerTrivia = NumberTrivia(number: 1, text: 'test');

  test(
    'should get trivia for the number from the repository',
    () async {
      when(() => mockNumberTriviaRepository.getConcreteNumberTrivia(any()))
          .thenAnswer((_) async => Right(tNubmerTrivia));
      final result = await usecase.execute(number: tNumber);

      expect(result, Right(tNubmerTrivia));

      verify(() => mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber));

      verifyNoMoreInteractions(mockNumberTriviaRepository);
    },
  );
}
