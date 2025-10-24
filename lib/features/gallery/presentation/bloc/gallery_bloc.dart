import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/delete_drawing_usecase.dart';
import '../../domain/usecases/get_drawings_usecase.dart';
import '../../domain/usecases/save_drawing_usecase.dart';
import 'gallery_event.dart';
import 'gallery_state.dart';

class GalleryBloc extends Bloc<GalleryEvent, GalleryState> {
  final GetDrawingsUseCase getDrawingsUseCase;
  final DeleteDrawingUseCase deleteDrawingUseCase;
  final SaveDrawingUseCase saveDrawingUseCase;

  GalleryBloc({
    required this.getDrawingsUseCase,
    required this.deleteDrawingUseCase,
    required this.saveDrawingUseCase,
  }) : super(GalleryInitial()) {
    on<LoadDrawingsEvent>(_onLoadDrawings);
    on<DeleteDrawingEvent>(_onDeleteDrawing);
    on<RefreshDrawingsEvent>(_onRefreshDrawings);
  }

  Future<void> _onLoadDrawings(
    LoadDrawingsEvent event,
    Emitter<GalleryState> emit,
  ) async {
    emit(GalleryLoading());

    final result = await getDrawingsUseCase(event.userId);

    result.fold((failure) => emit(GalleryError(failure.message)), (drawings) {
      if (drawings.isEmpty) {
        emit(GalleryEmpty());
      } else {
        emit(GalleryLoaded(drawings));
      }
    });
  }

  Future<void> _onDeleteDrawing(
    DeleteDrawingEvent event,
    Emitter<GalleryState> emit,
  ) async {
    final currentState = state;

    if (currentState is GalleryLoaded) {
      emit(GalleryLoading());

      final result = await deleteDrawingUseCase(event.drawingId);

      result.fold(
        (failure) {
          emit(GalleryLoaded(currentState.drawings));
          emit(GalleryError(failure.message));
        },
        (_) {
          final updatedDrawings = currentState.drawings
              .where((drawing) => drawing.id != event.drawingId)
              .toList();

          if (updatedDrawings.isEmpty) {
            emit(GalleryEmpty());
          } else {
            emit(GalleryLoaded(updatedDrawings));
          }
        },
      );
    }
  }

  Future<void> _onRefreshDrawings(
    RefreshDrawingsEvent event,
    Emitter<GalleryState> emit,
  ) async {
    final result = await getDrawingsUseCase(event.userId);

    result.fold((failure) => emit(GalleryError(failure.message)), (drawings) {
      if (drawings.isEmpty) {
        emit(GalleryEmpty());
      } else {
        emit(GalleryLoaded(drawings));
      }
    });
  }
}
