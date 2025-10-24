import 'package:equatable/equatable.dart';
import '../../domain/entities/drawing.dart';

abstract class GalleryState extends Equatable {
  const GalleryState();

  @override
  List<Object?> get props => [];
}

class GalleryInitial extends GalleryState {}

class GalleryLoading extends GalleryState {}

class GalleryLoaded extends GalleryState {
  final List<Drawing> drawings;

  const GalleryLoaded(this.drawings);

  @override
  List<Object?> get props => [drawings];
}

class GalleryEmpty extends GalleryState {}

class GalleryError extends GalleryState {
  final String message;

  const GalleryError(this.message);

  @override
  List<Object?> get props => [message];
}

class DrawingDeleted extends GalleryState {
  final String drawingId;

  const DrawingDeleted(this.drawingId);

  @override
  List<Object?> get props => [drawingId];
}
