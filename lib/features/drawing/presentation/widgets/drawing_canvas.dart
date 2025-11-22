import 'package:flutter/material.dart';
import '../../domain/entities/canvas_state.dart';

class DrawingCanvas extends CustomPainter {
  final CanvasState canvasState;

  DrawingCanvas({required this.canvasState});

  @override
  void paint(Canvas canvas, Size size) {
    if (canvasState.backgroundImage != null) {
      final image = canvasState.backgroundImage!;

      final src = Rect.fromLTWH(
        0,
        0,
        image.width.toDouble(),
        image.height.toDouble(),
      );
      final dst = Rect.fromLTWH(0, 0, size.width, size.height);

      canvas.drawImageRect(
        image,
        src, // откуда берём пиксели из исходного изображения.
        dst, // куда рисуем эти пиксели на canvas.
        Paint(),
      );
    } else {
      canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Paint()..color = Colors.white,
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
  }

  @override
  bool shouldRepaint(covariant DrawingCanvas oldDelegate) {
    // нужно ли перерисовывать canvas
    return oldDelegate.canvasState != canvasState;
  }
}
