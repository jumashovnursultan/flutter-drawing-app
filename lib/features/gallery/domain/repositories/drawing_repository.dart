import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/drawing.dart';

abstract class DrawingRepository {
  Future<Either<Failure, Drawing>> saveDrawing({
    required String userId,
    required String title,
    required String imageData,
    required String thumbnail,
    required String author,
  });

  Future<Either<Failure, List<Drawing>>> getDrawings(String userId);

  Future<Either<Failure, Drawing>> getDrawingById(String drawingId);

  Future<Either<Failure, Drawing>> updateDrawing({
    required String drawingId,
    required String imageData,
    required String thumbnail,
  });

  Future<Either<Failure, void>> deleteDrawing(String drawingId);
}
