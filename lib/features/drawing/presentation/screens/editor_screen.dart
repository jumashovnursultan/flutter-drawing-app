import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container/injection_container.dart' as di;
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../bloc/drawing_bloc.dart';
import '../bloc/drawing_event.dart';
import '../bloc/drawing_state.dart';
import '../widgets/brush_size_slider.dart';
import '../widgets/drawing_canvas.dart';
import '../widgets/save_dialog.dart';
import '../widgets/simple_color_picker.dart';
import '../widgets/tool_selector.dart';

class EditorScreen extends StatelessWidget {
  final String? drawingId;

  const EditorScreen({super.key, this.drawingId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<DrawingBloc>(),
      child: EditorScreenContent(drawingId: drawingId),
    );
  }
}

class EditorScreenContent extends StatefulWidget {
  final String? drawingId;

  const EditorScreenContent({super.key, this.drawingId});

  @override
  State<EditorScreenContent> createState() => _EditorScreenContentState();
}

class _EditorScreenContentState extends State<EditorScreenContent> {
  final GlobalKey _canvasKey = GlobalKey();

  Size _getCanvasSize() {
    final RenderBox? renderBox =
        _canvasKey.currentContext?.findRenderObject() as RenderBox?;
    return renderBox?.size ?? const Size(300, 400);
  }

  void _showColorPicker(BuildContext context, Color currentColor) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (bottomSheetContext) => SimpleColorPicker(
        selectedColor: currentColor,
        onColorSelected: (color) {
          context.read<DrawingBloc>().add(ChangeBrushColorEvent(color));
        },
      ),
    );
  }

  void _showBrushSizeSlider(BuildContext context, double currentSize) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (bottomSheetContext) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Размер кисти',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            BrushSizeSlider(
              brushSize: currentSize,
              onChanged: (size) {
                context.read<DrawingBloc>().add(ChangeBrushSizeEvent(size));
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(bottomSheetContext),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
              ),
              child: const Text('Готово'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSave(BuildContext context) async {
    final title = await showDialog<String>(
      context: context,
      builder: (dialogContext) => const SaveDialog(),
    );

    if (title == null || !context.mounted) return;

    final authState = context.read<AuthBloc>().state;
    if (authState is! AuthAuthenticated) return;

    context.read<DrawingBloc>().add(
      SaveDrawingEvent(
        userId: authState.user.id,
        userEmail: authState.user.email,
        title: title,
        canvasSize: _getCanvasSize(),
      ),
    );
  }

  void _handleExport(BuildContext context) {
    context.read<DrawingBloc>().add(ExportDrawingEvent(_getCanvasSize()));
  }

  void _handleImport(BuildContext context) {
    context.read<DrawingBloc>().add(ImportImageEvent());
  }

  void _showClearConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Очистить холст?'),
        content: const Text('Вы уверены? Это действие нельзя отменить.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<DrawingBloc>().add(ClearCanvasEvent());
            },
            child: const Text('Очистить', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.drawingId == null ? 'Новый рисунок' : 'Редактирование',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.image),
            tooltip: 'Импорт',
            onPressed: () => _handleImport(context),
          ),

          BlocBuilder<DrawingBloc, DrawingState>(
            builder: (context, state) {
              if (state.canvasState.backgroundImage != null) {
                return IconButton(
                  icon: const Icon(Icons.image_not_supported),
                  tooltip: 'Удалить фон',
                  onPressed: () {
                    context.read<DrawingBloc>().add(
                      ClearBackgroundImageEvent(),
                    );
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),

          IconButton(
            icon: const Icon(Icons.share),
            tooltip: 'Экспорт',
            onPressed: () => _handleExport(context),
          ),

          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Сохранить',
            onPressed: () => _handleSave(context),
          ),
        ],
      ),
      body: BlocConsumer<DrawingBloc, DrawingState>(
        listener: (context, state) {
          if (state is DrawingError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }

          if (state is DrawingSaved) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );

            Navigator.pop(context, true);
          }

          if (state is DrawingExported) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Рисунок экспортирован'),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        builder: (context, state) {
          final canvasState = state.canvasState;

          return Stack(
            children: [
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.grey.shade100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: canvasState.isEraser
                                ? Colors.white
                                : Color(canvasState.brushColor),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          canvasState.isEraser ? 'Ластик' : 'Кисть',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 16),
                        const Icon(Icons.circle, size: 12),
                        const SizedBox(width: 4),
                        Text(
                          'Размер: ${canvasState.brushSize.round()}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: GestureDetector(
                      key: _canvasKey,
                      onPanStart: (details) {
                        context.read<DrawingBloc>().add(
                          StartDrawingEvent(details.localPosition),
                        );
                      },
                      onPanUpdate: (details) {
                        context.read<DrawingBloc>().add(
                          DrawEvent(details.localPosition),
                        );
                      },
                      onPanEnd: (details) {
                        context.read<DrawingBloc>().add(EndDrawingEvent());
                      },
                      child: Container(
                        color: Colors.grey.shade200,
                        child: CustomPaint(
                          painter: DrawingCanvas(canvasState: canvasState),
                          child: Container(),
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: BrushSizeSlider(
                      brushSize: canvasState.brushSize,
                      onChanged: (size) {
                        context.read<DrawingBloc>().add(
                          ChangeBrushSizeEvent(size),
                        );
                      },
                    ),
                  ),

                  ToolSelector(
                    isEraser: canvasState.isEraser,
                    onBrushTap: () {
                      if (canvasState.isEraser) {
                        context.read<DrawingBloc>().add(ToggleEraserEvent());
                      }
                    },
                    onEraserTap: () {
                      if (!canvasState.isEraser) {
                        context.read<DrawingBloc>().add(ToggleEraserEvent());
                      }
                    },
                    onColorPickerTap: () {
                      _showColorPicker(context, Color(canvasState.brushColor));
                    },
                    onUndoTap: () {
                      context.read<DrawingBloc>().add(UndoEvent());
                    },
                    onClearTap: () {
                      _showClearConfirmation(context);
                    },
                  ),
                ],
              ),

              if (state is DrawingSaving)
                Container(
                  color: Colors.black54,
                  child: const Center(
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text(
                              'Сохранение...',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
