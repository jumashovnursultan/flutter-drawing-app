import 'dart:convert';
import 'package:flutter/material.dart';
import '../../domain/entities/drawing.dart';

class DrawingGridItem extends StatelessWidget {
  final Drawing drawing;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const DrawingGridItem({
    super.key,
    required this.drawing,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        onLongPress: onDelete,
        borderRadius: BorderRadius.circular(12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: drawing.thumbnail.isNotEmpty
              ? Image.memory(
                  base64Decode(drawing.thumbnail),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey.shade200,
                      child: const Icon(
                        Icons.broken_image,
                        size: 48,
                        color: Colors.grey,
                      ),
                    );
                  },
                )
              : Container(
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.image, size: 48, color: Colors.grey),
                ),
        ),
      ),
    );
  }
}
