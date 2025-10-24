import 'package:flutter/material.dart';

class BrushSizeSlider extends StatelessWidget {
  final double brushSize;
  final ValueChanged<double> onChanged;

  const BrushSizeSlider({
    super.key,
    required this.brushSize,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.circle, size: 8),
          Expanded(
            child: Slider(
              value: brushSize,
              min: 1.0,
              max: 50.0,
              divisions: 49,
              label: brushSize.round().toString(),
              activeColor: Colors.deepPurple,
              onChanged: onChanged,
            ),
          ),
          const Icon(Icons.circle, size: 24),
          const SizedBox(width: 8),
          Text(
            '${brushSize.round()}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
