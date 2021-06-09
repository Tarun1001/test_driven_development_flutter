
import 'package:app1/Features/number_trivia/Domain/Entities/number_trivia.dart';
import 'package:app1/core/errors/failures.dart';
import 'package:dartz/dartz.dart';

abstract class NumberTriviaRepository {

  Future<Either<Failure,NumberTrivia>> getConcreteNumberTrivia(int number);
  Future<Either<Failure,NumberTrivia>>getRandomNumberTrivia();
}
