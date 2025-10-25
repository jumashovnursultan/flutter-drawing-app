import 'package:drawing_app/features/drawing/presentation/bloc/drawing_bloc.dart';
import 'package:drawing_app/features/drawing/presentation/bloc/drawing_event.dart';
import 'package:drawing_app/features/drawing/presentation/bloc/drawing_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class ToolSelector extends StatelessWidget {
  final bool isEraser;
  final bool hasBackgroundImage;
  final VoidCallback onBrushTap;
  final VoidCallback onEraserTap;
  final VoidCallback onUndoTap;
  final VoidCallback onClearTap;
  final VoidCallback onClearBackground;
  final VoidCallback onExportTap;
  final VoidCallback onImportTap;
  final VoidCallback onPaletteTap;

  const ToolSelector({
    super.key,
    required this.isEraser,
    required this.hasBackgroundImage,
    required this.onBrushTap,
    required this.onEraserTap,
    required this.onUndoTap,
    required this.onClearTap,
    required this.onClearBackground,
    required this.onExportTap,
    required this.onImportTap,
    required this.onPaletteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: onExportTap,
          child: Container(
            height: 38,
            width: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF403F42),
            ),
            alignment: Alignment.center,
            child: SvgPicture.asset('assets/icons/save.svg'),
          ),
        ),
        SizedBox(width: 12),
        GestureDetector(
          onTap: onImportTap,
          child: Container(
            height: 38,
            width: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF403F42),
            ),
            alignment: Alignment.center,
            child: SvgPicture.asset('assets/icons/gallery.svg'),
          ),
        ),
        SizedBox(width: 12),
        GestureDetector(
          onTap: onBrushTap,
          child: Container(
            height: 38,
            width: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF403F42),
              border: isEraser
                  ? null
                  : Border.all(width: 1, color: Colors.white),
            ),
            alignment: Alignment.center,
            child: SvgPicture.asset('assets/icons/pencil.svg'),
          ),
        ),
        SizedBox(width: 12),
        GestureDetector(
          onTap: onEraserTap,
          child: Container(
            height: 38,
            width: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF403F42),
              border: isEraser
                  ? Border.all(width: 1, color: Colors.white)
                  : null,
            ),
            alignment: Alignment.center,
            child: SvgPicture.asset('assets/icons/eraser.svg'),
          ),
        ),
        SizedBox(width: 12),
        GestureDetector(
          onTap: onPaletteTap,
          child: Container(
            height: 38,
            width: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF403F42),
            ),
            alignment: Alignment.center,
            child: SvgPicture.asset('assets/icons/palette.svg'),
          ),
        ),
        SizedBox(width: 12),
        if (hasBackgroundImage) ...[
          GestureDetector(
            onTap: onClearBackground,
            child: Container(
              height: 38,
              width: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF403F42),
              ),
              alignment: Alignment.center,
              child: const Icon(Icons.image_not_supported),
            ),
          ),
          SizedBox(width: 12),
        ],

        GestureDetector(
          onTap: onClearTap,
          child: Container(
            height: 38,
            width: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF403F42),
            ),
            alignment: Alignment.center,
            child: Icon(Icons.delete_outline),
          ),
        ),
        SizedBox(width: 12),

        GestureDetector(
          onTap: onUndoTap,

          child: Container(
            height: 38,
            width: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF403F42),
            ),
            alignment: Alignment.center,
            child: Icon(Icons.undo),
          ),
        ),
      ],
    );
  }
}
