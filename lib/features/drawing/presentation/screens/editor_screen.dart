import 'package:drawing_app/core/constants/app_strings.dart';
import 'package:drawing_app/core/widgets/custom_app_bar.dart';
import 'package:drawing_app/core/widgets/gradient_background.dart';

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
import '../widgets/simple_color_picker.dart';
import '../widgets/tool_selector.dart';

class EditorScreen extends StatelessWidget {
  final String? drawingId;
  final String? imageBase64;

  const EditorScreen({super.key, this.drawingId, this.imageBase64});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = di.sl<DrawingBloc>();

        if (imageBase64 != null) {
          bloc.add(LoadExistingDrawingEvent(imageBase64!));
        }

        return bloc;
      },
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
    final renderBox =
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

  Future<void> _handleSave(BuildContext context) async {
    if (!context.mounted) return;

    final authState = context.read<AuthBloc>().state;
    if (authState is! AuthAuthenticated) return;

    context.read<DrawingBloc>().add(
      SaveDrawingEvent(
        userId: authState.user.id,
        userEmail: authState.user.email,
        title: DateTime.now().toIso8601String(),
        canvasSize: _getCanvasSize(),
        drawingId: widget.drawingId,
      ),
    );
  }

  void _handleExport(BuildContext context, Rect? sharePositionOrigin) {
    context.read<DrawingBloc>().add(
      ExportDrawingEvent(_getCanvasSize(), sharePositionOrigin),
    );
  }

  void _handleImport(BuildContext context) {
    context.read<DrawingBloc>().add(ImportImageEvent());
  }

  void _showClearConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(AppStrings.clearCanvasConfirm),
        content: const Text(AppStrings.clearCanvasMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<DrawingBloc>().add(ClearCanvasEvent());
            },
            child: const Text(
              AppStrings.clear,
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.drawingId == null
            ? AppStrings.newImage
            : AppStrings.editing,
        actions: [
          IconButton(
            onPressed: () => _handleSave(context),
            icon: Icon(Icons.check),
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
                content: Text(AppStrings.drawingExported),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        builder: (context, state) {
          final canvasState = state.canvasState;
          return GradientBackground(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Stack(
                children: [
                  Column(
                    children: [
                      SizedBox(height: 24),

                      BlocBuilder<DrawingBloc, DrawingState>(
                        builder: (context, state) {
                          return ToolSelector(
                            isEraser: canvasState.isEraser,
                            hasBackgroundImage:
                                state.canvasState.backgroundImage != null,

                            onBrushTap: () {
                              if (canvasState.isEraser) {
                                context.read<DrawingBloc>().add(
                                  ToggleEraserEvent(),
                                );
                              }
                            },
                            onEraserTap: () {
                              if (!canvasState.isEraser) {
                                context.read<DrawingBloc>().add(
                                  ToggleEraserEvent(),
                                );
                              }
                            },
                            onExportTap: (sharePositionOrigin) async =>
                                _handleExport(context, sharePositionOrigin),
                            onImportTap: () => _handleImport(context),
                            onPaletteTap: () => _showColorPicker(
                              context,
                              Color(canvasState.brushColor),
                            ),
                            onClearTap: () => _showClearConfirmation(context),
                            onClearBackground: () => context
                                .read<DrawingBloc>()
                                .add(ClearBackgroundImageEvent()),
                            onUndoTap: () =>
                                context.read<DrawingBloc>().add(UndoEvent()),
                          );
                        },
                      ),
                      SizedBox(height: 24),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
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
                              context.read<DrawingBloc>().add(
                                EndDrawingEvent(),
                              );
                            },
                            child: Container(
                              color: Colors.grey.shade200,
                              child: CustomPaint(
                                painter: DrawingCanvas(
                                  canvasState: canvasState,
                                ),
                                child: Container(),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      BrushSizeSlider(
                        brushSize: canvasState.brushSize,
                        onChanged: (size) {
                          context.read<DrawingBloc>().add(
                            ChangeBrushSizeEvent(size),
                          );
                        },
                      ),
                      SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(8),

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
                              canvasState.isEraser
                                  ? AppStrings.eraser
                                  : AppStrings.brush,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Icon(Icons.circle, size: 12),
                            const SizedBox(width: 4),
                            Text(
                              AppStrings.brushSize(
                                canvasState.brushSize.round(),
                              ),
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30),
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
                                  AppStrings.saving,
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
