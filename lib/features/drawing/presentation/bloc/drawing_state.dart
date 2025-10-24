import 'package:equatable/equatable.dart';
import '../../domain/entities/canvas_state.dart';

abstract class DrawingState extends Equatable {
  final CanvasState canvasState;

  const DrawingState(this.canvasState);

  @override
  List<Object?> get props => [canvasState];
}

class DrawingInitial extends DrawingState {
  const DrawingInitial() : super(const CanvasState.initial());
}

class DrawingInProgress extends DrawingState {
  const DrawingInProgress(super.canvasState);
}

class DrawingSaving extends DrawingState {
  const DrawingSaving(super.canvasState);
}

class DrawingSaved extends DrawingState {
  final String message;

  const DrawingSaved(super.canvasState, this.message);

  @override
  List<Object?> get props => [canvasState, message];
}

class DrawingError extends DrawingState {
  final String message;

  const DrawingError(super.canvasState, this.message);

  @override
  List<Object?> get props => [canvasState, message];
}

class DrawingExported extends DrawingState {
  const DrawingExported(super.canvasState);
}
