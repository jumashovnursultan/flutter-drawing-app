import 'package:flutter/material.dart';
import '../../domain/entities/canvas_state.dart';

class DrawingCanvas extends CustomPainter {
  final CanvasState canvasState;

  DrawingCanvas({required this.canvasState});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = Colors.white,
    );

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
    return oldDelegate.canvasState != canvasState;
  }
}
