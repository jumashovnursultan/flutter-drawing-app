import 'dart:ui';
import 'package:drawing_app/core/services/notification_service.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/image_helper.dart';
import '../../../gallery/domain/usecases/save_drawing_usecase.dart';
import '../../data/services/image_service.dart';

import '../../domain/entities/drawing_point.dart';
import '../../domain/usecases/export_drawing_usecase.dart';
import 'drawing_event.dart';
import 'drawing_state.dart';

class DrawingBloc extends Bloc<DrawingEvent, DrawingState> {
  final ExportDrawingUseCase exportDrawingUseCase;
  final SaveDrawingUseCase saveDrawingUseCase;
  final ImageService imageService;
  final NotificationService notificationService;

  List<DrawingPoint> _currentStroke = [];

  DrawingBloc({
    required this.exportDrawingUseCase,
    required this.saveDrawingUseCase,
    required this.imageService,
    required this.notificationService,
  }) : super(const DrawingInitial()) {
    on<StartDrawingEvent>(_onStartDrawing);
    on<DrawEvent>(_onDraw);
    on<EndDrawingEvent>(_onEndDrawing);
    on<ChangeBrushSizeEvent>(_onChangeBrushSize);
    on<ChangeBrushColorEvent>(_onChangeBrushColor);
    on<ToggleEraserEvent>(_onToggleEraser);
    on<ClearCanvasEvent>(_onClearCanvas);
    on<UndoEvent>(_onUndo);
    on<ImportImageEvent>(_onImportImage);
    on<SetBackgroundImageEvent>(_onSetBackgroundImage);
    on<LoadExistingDrawingEvent>(_onLoadExistingDrawing);
    on<ClearBackgroundImageEvent>(_onClearBackgroundImage);
    on<ExportDrawingEvent>(_onExportDrawing);
    on<SaveDrawingEvent>(_onSaveDrawing);
  }

  Paint _getCurrentPaint() {
    return Paint()
      ..color = state.canvasState.isEraser
          ? const Color(0xFFFFFFFF)
          : Color(state.canvasState.brushColor)
      ..strokeWidth = state.canvasState.brushSize
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
  }

  void _onStartDrawing(StartDrawingEvent event, Emitter<DrawingState> emit) {
    _currentStroke = [
      DrawingPoint(offset: event.point, paint: _getCurrentPaint()),
    ];
  }

  void _onDraw(DrawEvent event, Emitter<DrawingState> emit) {
    _currentStroke.add(
      DrawingPoint(offset: event.point, paint: _getCurrentPaint()),
    );

    final updatedStrokes = List<List<DrawingPoint>>.from(
      state.canvasState.strokes,
    )..add(List.from(_currentStroke));

    emit(
      DrawingInProgress(state.canvasState.copyWith(strokes: updatedStrokes)),
    );
  }

  void _onEndDrawing(EndDrawingEvent event, Emitter<DrawingState> emit) {
    if (_currentStroke.isEmpty) return;

    final updatedStrokes = List<List<DrawingPoint>>.from(
      state.canvasState.strokes,
    )..add(List.from(_currentStroke));

    _currentStroke = [];

    emit(
      DrawingInProgress(state.canvasState.copyWith(strokes: updatedStrokes)),
    );
  }

  void _onChangeBrushSize(
    ChangeBrushSizeEvent event,
    Emitter<DrawingState> emit,
  ) {
    emit(DrawingInProgress(state.canvasState.copyWith(brushSize: event.size)));
  }

  void _onChangeBrushColor(
    ChangeBrushColorEvent event,
    Emitter<DrawingState> emit,
  ) {
    emit(
      DrawingInProgress(
        state.canvasState.copyWith(
          brushColor: event.color.value,
          isEraser: false,
        ),
      ),
    );
  }

  void _onToggleEraser(ToggleEraserEvent event, Emitter<DrawingState> emit) {
    emit(
      DrawingInProgress(
        state.canvasState.copyWith(isEraser: !state.canvasState.isEraser),
      ),
    );
  }

  void _onClearCanvas(ClearCanvasEvent event, Emitter<DrawingState> emit) {
    emit(
      DrawingInProgress(
        state.canvasState.copyWith(strokes: [], clearBackground: true),
      ),
    );
  }

  void _onUndo(UndoEvent event, Emitter<DrawingState> emit) {
    if (state.canvasState.strokes.isEmpty) return;

    final updatedStrokes = List<List<DrawingPoint>>.from(
      state.canvasState.strokes,
    )..removeLast();

    emit(
      DrawingInProgress(state.canvasState.copyWith(strokes: updatedStrokes)),
    );
  }

  Future<void> _onImportImage(
    ImportImageEvent event,
    Emitter<DrawingState> emit,
  ) async {
    try {
      final image = await imageService.importFromGallery();
      if (image == null) return;

      add(SetBackgroundImageEvent(image));
    } catch (e) {
      emit(DrawingError(state.canvasState, 'Ошибка импорта: $e'));
      emit(DrawingInProgress(state.canvasState));
    }
  }

  void _onSetBackgroundImage(
    SetBackgroundImageEvent event,
    Emitter<DrawingState> emit,
  ) {
    emit(
      DrawingInProgress(
        state.canvasState.copyWith(backgroundImage: event.image, strokes: []),
      ),
    );
  }

  Future<void> _onLoadExistingDrawing(
    LoadExistingDrawingEvent event,
    Emitter<DrawingState> emit,
  ) async {
    try {
      final image = await ImageHelper.base64ToImage(event.imageBase64);

      emit(
        DrawingInProgress(
          state.canvasState.copyWith(backgroundImage: image, strokes: []),
        ),
      );
    } catch (e) {
      emit(DrawingError(state.canvasState, 'Ошибка загрузки рисунка: $e'));
      emit(DrawingInProgress(state.canvasState));
    }
  }

  void _onClearBackgroundImage(
    ClearBackgroundImageEvent event,
    Emitter<DrawingState> emit,
  ) {
    emit(DrawingInProgress(state.canvasState.copyWith(clearBackground: true)));
  }

  Future<void> _onExportDrawing(
    ExportDrawingEvent event,
    Emitter<DrawingState> emit,
  ) async {
    try {
      emit(DrawingSaving(state.canvasState));

      final result = await exportDrawingUseCase(
        state.canvasState,
        event.canvasSize,
      );

      await result.fold(
        (failure) async {
          emit(DrawingError(state.canvasState, failure.message));
        },
        (image) async {
          await imageService.shareImage(image);

          await notificationService.showNotification(
            title: '🎨 Рисунок сохранён',
            body: '',
          );

          emit(DrawingExported(state.canvasState));
          emit(DrawingInProgress(state.canvasState));
        },
      );
    } catch (e) {
      emit(DrawingError(state.canvasState, 'Ошибка экспорта: $e'));
      emit(DrawingInProgress(state.canvasState));
    }
  }

  Future<void> _onSaveDrawing(
    SaveDrawingEvent event,
    Emitter<DrawingState> emit,
  ) async {
    try {
      emit(DrawingSaving(state.canvasState));

      final exportResult = await exportDrawingUseCase(
        state.canvasState,
        event.canvasSize,
      );

      await exportResult.fold(
        (failure) async {
          emit(DrawingError(state.canvasState, failure.message));
        },
        (image) async {
          final imageBase64 = await ImageHelper.imageToBase64(image);

          final thumbnailBase64 = await ImageHelper.createThumbnail(
            image,
            maxWidth: 200,
            maxHeight: 200,
          );

          final saveResult = await saveDrawingUseCase(
            userId: event.userId,
            title: event.title,
            imageData: imageBase64,
            thumbnail: thumbnailBase64,
            author: event.userEmail,
            drawingId: event.drawingId,
          );

          await saveResult.fold(
            (failure) async {
              emit(DrawingError(state.canvasState, failure.message));
            },
            (drawing) async {
              try {
                await imageService.saveToGallery(image);
              } catch (e) {}

              await notificationService.showNotification(
                title: '🎨 Рисунок сохранён',
                body: event.title,
              );

              emit(
                DrawingSaved(
                  state.canvasState,
                  event.drawingId != null
                      ? 'Рисунок обновлен'
                      : 'Рисунок сохранен',
                ),
              );

              await Future.delayed(const Duration(seconds: 1));
              emit(DrawingInProgress(state.canvasState));
            },
          );
        },
      );
    } catch (e) {
      emit(DrawingError(state.canvasState, 'Ошибка сохранения: $e'));
      emit(DrawingInProgress(state.canvasState));
    }
  }
}
