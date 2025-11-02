import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ToolSelector extends StatelessWidget {
  final bool isEraser;
  final bool hasBackgroundImage;
  final VoidCallback onBrushTap;
  final VoidCallback onEraserTap;
  final VoidCallback onUndoTap;
  final VoidCallback onClearTap;
  final VoidCallback onClearBackground;
  final Function(Rect?) onExportTap;
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
    final shareButtonKey = GlobalKey();

    return Align(
      alignment: Alignment.centerRight,
      child: SingleChildScrollView(
        reverse: true,
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                final box =
                    shareButtonKey.currentContext?.findRenderObject()
                        as RenderBox?;
                final sharePositionOrigin = box != null
                    ? box.localToGlobal(Offset.zero) & box.size
                    : null;

                onExportTap(sharePositionOrigin);
              },
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
        ),
      ),
    );
  }
}
