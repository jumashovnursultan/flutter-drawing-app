import 'package:drawing_app/core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class SimpleColorPicker extends StatefulWidget {
  final Color selectedColor;
  final ValueChanged<Color> onColorSelected;

  const SimpleColorPicker({
    super.key,
    required this.selectedColor,
    required this.onColorSelected,
  });

  @override
  State<SimpleColorPicker> createState() => _SimpleColorPickerState();
}

class _SimpleColorPickerState extends State<SimpleColorPicker> {
  late Color _currentColor;

  @override
  void initState() {
    super.initState();
    _currentColor = widget.selectedColor;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            AppStrings.selectColor,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          ColorPicker(
            pickerColor: _currentColor,
            onColorChanged: (color) {
              setState(() => _currentColor = color);
              widget.onColorSelected(color);
            },
            pickerAreaHeightPercent: 0.8,
            enableAlpha: false,
            displayThumbColor: true,
            paletteType: PaletteType.hueWheel,
          ),

          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
            ),
            child: const Text(AppStrings.done),
          ),
        ],
      ),
    );
  }
}
