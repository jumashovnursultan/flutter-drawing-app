import 'package:flutter/material.dart';

class ToolSelector extends StatelessWidget {
  final bool isEraser;
  final VoidCallback onBrushTap;
  final VoidCallback onEraserTap;
  final VoidCallback onUndoTap;
  final VoidCallback onClearTap;
  final VoidCallback onColorPickerTap;

  const ToolSelector({
    super.key,
    required this.isEraser,
    required this.onBrushTap,
    required this.onEraserTap,
    required this.onUndoTap,
    required this.onClearTap,
    required this.onColorPickerTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _ToolButton(
            icon: Icons.brush,
            label: 'Кисть',
            isSelected: !isEraser,
            onTap: onBrushTap,
          ),

          _ToolButton(
            icon: Icons.auto_fix_high,
            label: 'Ластик',
            isSelected: isEraser,
            onTap: onEraserTap,
          ),

          _ToolButton(
            icon: Icons.palette,
            label: 'Цвет',
            onTap: onColorPickerTap,
          ),

          _ToolButton(icon: Icons.undo, label: 'Отменить', onTap: onUndoTap),

          _ToolButton(
            icon: Icons.delete_outline,
            label: 'Очистить',
            onTap: onClearTap,
            color: Colors.red,
          ),
        ],
      ),
    );
  }
}

class _ToolButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? color;

  const _ToolButton({
    required this.icon,
    required this.label,
    this.isSelected = false,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.deepPurple.withOpacity(0.1) : null,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Colors.deepPurple
                  : (color ?? Colors.grey.shade700),
              size: 28,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: isSelected
                    ? Colors.deepPurple
                    : (color ?? Colors.grey.shade700),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
