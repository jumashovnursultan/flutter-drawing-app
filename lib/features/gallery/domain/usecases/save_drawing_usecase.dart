import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/drawing.dart';
import '../repositories/drawing_repository.dart';

class SaveDrawingUseCase {
  final DrawingRepository repository;

  SaveDrawingUseCase(this.repository);

  Future<Either<Failure, Drawing>> call({
    required String userId,
    required String title,
    required String imageData,
    required String thumbnail,
    required String author,
  }) async {
    return await repository.saveDrawing(
      userId: userId,
      title: title,
      imageData: imageData,
      thumbnail: thumbnail,
      author: author,
    );
  }
}
