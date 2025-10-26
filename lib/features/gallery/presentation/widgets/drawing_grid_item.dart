import 'dart:convert';
import 'package:drawing_app/core/cache/thumbnail_cache.dart';
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
    final cache = ThumbnailCache();
    var thumbnailBytes = cache.getThumbnail(drawing.id);

    if (thumbnailBytes == null) {
      thumbnailBytes = base64Decode(drawing.thumbnail);
      cache.cacheThumbnail(drawing.id, drawing.thumbnail);
      print('🔄 Cached thumbnail for: ${drawing.title}');
    } else {
      print('✅ Using cached thumbnail for: ${drawing.title}');
    }
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
                  thumbnailBytes,
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
