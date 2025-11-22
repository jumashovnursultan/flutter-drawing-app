import 'dart:ui' as ui;
import 'package:dartz/dartz.dart';
import 'package:drawing_app/core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import '../../../../core/errors/failures.dart';
import '../entities/canvas_state.dart';

class ExportDrawingUseCase {
  Future<Either<Failure, ui.Image>> call(
    CanvasState canvasState,
    Size size,
  ) async {
    try {
      final recorder = ui.PictureRecorder(); // Записывает все что ты рисуешь
      final canvas = Canvas(recorder); // холст для рисования

      if (canvasState.backgroundImage != null) {
        final image = canvasState.backgroundImage!;
        final src = Rect.fromLTWH(
          0,
          0,
          image.width.toDouble(),
          image.height.toDouble(),
        );
        final dst = Rect.fromLTWH(0, 0, size.width, size.height);
        canvas.drawImageRect(image, src, dst, Paint()); // рисует картинку
      } else {
        canvas.drawRect(
          Rect.fromLTWH(0, 0, size.width, size.height),
          Paint()..color = const ui.Color(0xFFFFFFFF),
        ); // рисует закрашенный белый прямоугольник
      }

      for (final stroke in canvasState.strokes) {
        // Рисует все линии на холсте

        if (stroke.isEmpty) {
          continue; // если линия пустая (нет точек) → пропусти её.
        }
        for (int i = 0; i < stroke.length - 1; i++) {
          final p1 = stroke[i];
          final p2 = stroke[i + 1];
          canvas.drawLine(
            p1.offset, // текущая точка
            p2.offset, // // следующая точка
            p1.paint, //настройки (цвет, толщина)
          );
        }
      }

      final picture = recorder.endRecording();
      final image = await picture.toImage(
        size.width.toInt(),
        size.height.toInt(),
      );

      return Right(image);
    } catch (e) {
      return Left(ServerFailure(AppStrings.exportError(e.toString())));
    }
  }
}
