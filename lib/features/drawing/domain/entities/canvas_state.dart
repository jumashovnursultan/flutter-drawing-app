import 'package:equatable/equatable.dart';
import 'drawing_point.dart';

class CanvasState extends Equatable {
  final List<List<DrawingPoint>> strokes;
  final double brushSize;
  final int brushColor;
  final bool isEraser;

  const CanvasState({
    required this.strokes,
    required this.brushSize,
    required this.brushColor,
    required this.isEraser,
  });

  const CanvasState.initial()
    : strokes = const [],
      brushSize = 5.0,
      brushColor = 0xFF000000,
      isEraser = false;

  CanvasState copyWith({
    List<List<DrawingPoint>>? strokes,
    double? brushSize,
    int? brushColor,
    bool? isEraser,
  }) {
    return CanvasState(
      strokes: strokes ?? this.strokes,
      brushSize: brushSize ?? this.brushSize,
      brushColor: brushColor ?? this.brushColor,
      isEraser: isEraser ?? this.isEraser,
    );
  }

  @override
  List<Object?> get props => [strokes, brushSize, brushColor, isEraser];
}
