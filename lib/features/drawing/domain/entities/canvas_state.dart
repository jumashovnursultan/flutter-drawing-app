import 'dart:ui' as ui;
import 'package:equatable/equatable.dart';
import 'drawing_point.dart';

class CanvasState extends Equatable {
  final List<List<DrawingPoint>> strokes;
  final double brushSize;
  final int brushColor;
  final bool isEraser;
  final ui.Image? backgroundImage;

  const CanvasState({
    required this.strokes,
    required this.brushSize,
    required this.brushColor,
    required this.isEraser,
    this.backgroundImage,
  });

  const CanvasState.initial()
    : strokes = const [],
      brushSize = 5.0,
      brushColor = 0xFF000000,
      isEraser = false,
      backgroundImage = null;

  CanvasState copyWith({
    List<List<DrawingPoint>>? strokes,
    double? brushSize,
    int? brushColor,
    bool? isEraser,
    ui.Image? backgroundImage,
    bool clearBackground = false,
  }) {
    return CanvasState(
      strokes: strokes ?? this.strokes,
      brushSize: brushSize ?? this.brushSize,
      brushColor: brushColor ?? this.brushColor,
      isEraser: isEraser ?? this.isEraser,
      backgroundImage: clearBackground
          ? null
          : (backgroundImage ?? this.backgroundImage),
    );
  }

  @override
  List<Object?> get props => [
    strokes,
    brushSize,
    brushColor,
    isEraser,
    backgroundImage,
  ];
}
