import 'dart:ui' as ui;
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import '../../../../core/errors/failures.dart';
import '../entities/canvas_state.dart';

class ExportDrawingUseCase {
  Future<Either<Failure, ui.Image>> call(
    CanvasState canvasState,
    Size size,
  ) async {
    try {
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);

      if (canvasState.backgroundImage != null) {
        final image = canvasState.backgroundImage!;
        final src = Rect.fromLTWH(
          0,
          0,
          image.width.toDouble(),
          image.height.toDouble(),
        );
        final dst = Rect.fromLTWH(0, 0, size.width, size.height);
        canvas.drawImageRect(image, src, dst, Paint());
      } else {
        canvas.drawRect(
          Rect.fromLTWH(0, 0, size.width, size.height),
          Paint()..color = const ui.Color(0xFFFFFFFF),
        );
      }

      for (final stroke in canvasState.strokes) {
        if (stroke.isEmpty) continue;

        for (int i = 0; i < stroke.length - 1; i++) {
          final p1 = stroke[i];
          final p2 = stroke[i + 1];
          canvas.drawLine(p1.offset, p2.offset, p1.paint);
        }
      }

      final picture = recorder.endRecording();
      final image = await picture.toImage(
        size.width.toInt(),
        size.height.toInt(),
      );

      return Right(image);
    } catch (e) {
      return Left(ServerFailure('Ошибка экспорта: $e'));
    }
  }
}
