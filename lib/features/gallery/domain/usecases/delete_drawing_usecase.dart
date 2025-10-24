import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/drawing_repository.dart';

class DeleteDrawingUseCase {
  final DrawingRepository repository;

  DeleteDrawingUseCase(this.repository);

  Future<Either<Failure, void>> call(String drawingId) async {
    return await repository.deleteDrawing(drawingId);
  }
}
