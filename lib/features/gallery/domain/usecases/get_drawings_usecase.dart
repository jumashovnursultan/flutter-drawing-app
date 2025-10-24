import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/drawing.dart';
import '../repositories/drawing_repository.dart';

class GetDrawingsUseCase {
  final DrawingRepository repository;

  GetDrawingsUseCase(this.repository);

  Future<Either<Failure, List<Drawing>>> call(String userId) async {
    return await repository.getDrawings(userId);
  }
}
