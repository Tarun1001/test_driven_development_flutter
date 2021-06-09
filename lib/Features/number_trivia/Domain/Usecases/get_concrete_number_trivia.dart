import 'package:app1/Features/number_trivia/Domain/Entities/number_trivia.dart';
import 'package:app1/Features/number_trivia/Domain/Repository/number_trivia_repository.dart';
import 'package:app1/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';

class GetConcreteNumberTrivia {
  final NumberTriviaRepository repository;

  GetConcreteNumberTrivia(this.repository);

  Future<Either<Failure, NumberTrivia>> execute({required int number}) async {
    return await repository.getConcreteNumberTrivia(number);
  }
}
