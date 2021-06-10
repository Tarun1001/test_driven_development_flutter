import '../../../../core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';

import '../Entities/number_trivia.dart';
import '../Repository/number_trivia_repository.dart';
import '../../../../core/errors/failures.dart';
import 'package:equatable/equatable.dart';

class GetRandomNumberTrivia extends Usecase<NumberTrivia,NoParams> {
  NumberTriviaRepository repository;
  GetRandomNumberTrivia({
    required this.repository,
  });



  Future<Either<Failure, NumberTrivia>> call(NoParams noParams) async {
    return await repository.getRandomNumberTrivia();
  }
}
class NoParams extends Equatable{
  @override
  List<Object?> get props => [];
}
