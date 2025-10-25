import 'dart:ui';
import 'dart:ui' as ui;
import 'package:equatable/equatable.dart';

abstract class DrawingEvent extends Equatable {
  const DrawingEvent();

  @override
  List<Object?> get props => [];
}

class StartDrawingEvent extends DrawingEvent {
  final Offset point;

  const StartDrawingEvent(this.point);

  @override
  List<Object?> get props => [point];
}

class DrawEvent extends DrawingEvent {
  final Offset point;

  const DrawEvent(this.point);

  @override
  List<Object?> get props => [point];
}

class EndDrawingEvent extends DrawingEvent {}

class ChangeBrushSizeEvent extends DrawingEvent {
  final double size;

  const ChangeBrushSizeEvent(this.size);

  @override
  List<Object?> get props => [size];
}

class ChangeBrushColorEvent extends DrawingEvent {
  final Color color;

  const ChangeBrushColorEvent(this.color);

  @override
  List<Object?> get props => [color];
}

class ToggleEraserEvent extends DrawingEvent {}

class ClearCanvasEvent extends DrawingEvent {}

class UndoEvent extends DrawingEvent {}

class ImportImageEvent extends DrawingEvent {}

class ExportDrawingEvent extends DrawingEvent {
  final Size canvasSize;

  const ExportDrawingEvent(this.canvasSize);

  @override
  List<Object?> get props => [canvasSize];
}

class SaveDrawingEvent extends DrawingEvent {
  final String userId;
  final String userEmail;
  final String title;
  final Size canvasSize;
  final String? drawingId;

  const SaveDrawingEvent({
    required this.userId,
    required this.userEmail,
    required this.title,
    required this.canvasSize,
    this.drawingId,
  });

  @override
  List<Object?> get props => [userId, userEmail, title, canvasSize, drawingId];
}

class SetBackgroundImageEvent extends DrawingEvent {
  final ui.Image image;

  const SetBackgroundImageEvent(this.image);

  @override
  List<Object?> get props => [image];
}

class LoadExistingDrawingEvent extends DrawingEvent {
  final String imageBase64;

  const LoadExistingDrawingEvent(this.imageBase64);

  @override
  List<Object?> get props => [imageBase64];
}

class ClearBackgroundImageEvent extends DrawingEvent {}
