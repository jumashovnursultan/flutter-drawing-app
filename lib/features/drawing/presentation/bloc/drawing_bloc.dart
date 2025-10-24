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

  // Текущий штрих (пока не завершен)
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
    on<ExportDrawingEvent>(_onExportDrawing);
    on<SaveDrawingEvent>(_onSaveDrawing);
  }

  /// Создание Paint объекта для текущей кисти
  Paint _getCurrentPaint() {
    return Paint()
      ..color = state.canvasState.isEraser
          ? const Color(0xFFFFFFFF) // Белый для ластика
          : Color(state.canvasState.brushColor)
      ..strokeWidth = state.canvasState.brushSize
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
  }

  /// Начало рисования
  void _onStartDrawing(StartDrawingEvent event, Emitter<DrawingState> emit) {
    _currentStroke = [
      DrawingPoint(offset: event.point, paint: _getCurrentPaint()),
    ];
  }

  /// Продолжение рисования
  void _onDraw(DrawEvent event, Emitter<DrawingState> emit) {
    _currentStroke.add(
      DrawingPoint(offset: event.point, paint: _getCurrentPaint()),
    );

    // Обновляем состояние с текущим штрихом
    final updatedStrokes = List<List<DrawingPoint>>.from(
      state.canvasState.strokes,
    )..add(List.from(_currentStroke));

    emit(
      DrawingInProgress(state.canvasState.copyWith(strokes: updatedStrokes)),
    );
  }

  /// Конец рисования
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

  /// Изменение размера кисти
  void _onChangeBrushSize(
    ChangeBrushSizeEvent event,
    Emitter<DrawingState> emit,
  ) {
    emit(DrawingInProgress(state.canvasState.copyWith(brushSize: event.size)));
  }

  /// Изменение цвета кисти
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

  /// Переключение ластика
  void _onToggleEraser(ToggleEraserEvent event, Emitter<DrawingState> emit) {
    emit(
      DrawingInProgress(
        state.canvasState.copyWith(isEraser: !state.canvasState.isEraser),
      ),
    );
  }

  /// Очистка холста
  void _onClearCanvas(ClearCanvasEvent event, Emitter<DrawingState> emit) {
    emit(DrawingInProgress(state.canvasState.copyWith(strokes: [])));
  }

  /// Отмена последнего штриха
  void _onUndo(UndoEvent event, Emitter<DrawingState> emit) {
    if (state.canvasState.strokes.isEmpty) return;

    final updatedStrokes = List<List<DrawingPoint>>.from(
      state.canvasState.strokes,
    )..removeLast();

    emit(
      DrawingInProgress(state.canvasState.copyWith(strokes: updatedStrokes)),
    );
  }

  /// Импорт изображения из галереи
  Future<void> _onImportImage(
    ImportImageEvent event,
    Emitter<DrawingState> emit,
  ) async {
    try {
      final image = await imageService.importFromGallery();
      if (image == null) return;

      emit(DrawingInProgress(state.canvasState));
    } catch (e) {
      emit(DrawingError(state.canvasState, 'Ошибка импорта: $e'));
    }
  }

  /// Экспорт через Share
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

          // ✅ ДОБАВЬ ЭТО: Показываем уведомление
          await notificationService.showDrawingExportedNotification();

          emit(DrawingExported(state.canvasState));
          emit(DrawingInProgress(state.canvasState));
        },
      );
    } catch (e) {
      emit(DrawingError(state.canvasState, 'Ошибка экспорта: $e'));
      emit(DrawingInProgress(state.canvasState));
    }
  }

  /// Сохранение в Firebase + галерею
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

          // 4. Сохраняем в Firebase
          final saveResult = await saveDrawingUseCase(
            userId: event.userId,
            title: event.title,
            imageData: imageBase64,
            thumbnail: thumbnailBase64,
            author: event.userEmail,
          );

          await saveResult.fold(
            (failure) async {
              emit(DrawingError(state.canvasState, failure.message));
            },
            (drawing) async {
              // 5. Сохраняем в галерею устройства
              try {
                await imageService.saveToGallery(image);
              } catch (e) {}

              await notificationService.showDrawingSavedNotification(
                title: '🎨 Рисунок сохранён',
                drawingName: event.title,
              );

              emit(
                DrawingSaved(state.canvasState, 'Рисунок сохранен успешно!'),
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
