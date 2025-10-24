import 'package:equatable/equatable.dart';

abstract class GalleryEvent extends Equatable {
  const GalleryEvent();

  @override
  List<Object?> get props => [];
}

class LoadDrawingsEvent extends GalleryEvent {
  final String userId;

  const LoadDrawingsEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class DeleteDrawingEvent extends GalleryEvent {
  final String drawingId;

  const DeleteDrawingEvent(this.drawingId);

  @override
  List<Object?> get props => [drawingId];
}

class RefreshDrawingsEvent extends GalleryEvent {
  final String userId;

  const RefreshDrawingsEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}
