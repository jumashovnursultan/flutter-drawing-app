import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/drawing.dart';
import '../../domain/repositories/drawing_repository.dart';
import '../datasources/firestore_datasource.dart';
import '../models/drawing_model.dart';

class DrawingRepositoryImpl implements DrawingRepository {
  final FirestoreDataSource dataSource;

  DrawingRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, Drawing>> saveDrawing({
    required String userId,
    required String title,
    required String imageData,
    required String thumbnail,
    required String author,
    String? drawingId,
  }) async {
    try {
      final drawing = DrawingModel(
        id: drawingId ?? '',
        userId: userId,
        title: title,
        imageData: imageData,
        thumbnail: thumbnail,
        author: author,
        date: DateTime.now(),
      );

      final savedDrawing = await dataSource.saveDrawing(drawing);
      return Right(savedDrawing);
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Drawing>>> getDrawings(String userId) async {
    try {
      final drawings = await dataSource.getDrawings(userId);
      return Right(drawings);
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Drawing>> getDrawingById(String drawingId) async {
    try {
      final drawing = await dataSource.getDrawingById(drawingId);
      return Right(drawing);
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Drawing>> updateDrawing({
    required String drawingId,
    required String imageData,
    required String thumbnail,
  }) async {
    try {
      final currentDrawing = await dataSource.getDrawingById(drawingId);

      final updatedDrawing = DrawingModel(
        id: currentDrawing.id,
        userId: currentDrawing.userId,
        title: currentDrawing.title,
        imageData: imageData,
        thumbnail: thumbnail,
        author: currentDrawing.author,
        date: DateTime.now(),
      );

      final drawing = await dataSource.updateDrawing(updatedDrawing);
      return Right(drawing);
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteDrawing(String drawingId) async {
    try {
      await dataSource.deleteDrawing(drawingId);
      return const Right(null);
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
