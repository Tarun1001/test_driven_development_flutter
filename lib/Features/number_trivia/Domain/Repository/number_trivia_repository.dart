
import '../Entities/number_trivia.dart';
import '../../../../core/errors/failures.dart';
import 'package:dartz/dartz.dart';

abstract class NumberTriviaRepository {

  Future<Either<Failure,NumberTrivia>> getConcreteNumberTrivia(int number);
  Future<Either<Failure,NumberTrivia>> getRandomNumberTrivia();
}
