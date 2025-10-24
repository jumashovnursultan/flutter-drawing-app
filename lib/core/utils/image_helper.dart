import 'dart:convert';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class ImageHelper {
  static Future<String> imageToBase64(ui.Image image) async {
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final bytes = byteData!.buffer.asUint8List();
    return base64Encode(bytes);
  }

  static Future<ui.Image> base64ToImage(String base64String) async {
    final bytes = base64Decode(base64String);
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    return frame.image;
  }

  /// Создание thumbnail
  static Future<String> createThumbnail(
    ui.Image image, {
    int maxWidth = 200,
    int maxHeight = 200,
  }) async {
    final aspectRatio = image.width / image.height;
    int thumbnailWidth = maxWidth;
    int thumbnailHeight = maxHeight;

    if (aspectRatio > 1) {
      thumbnailHeight = (maxWidth / aspectRatio).round();
    } else {
      thumbnailWidth = (maxHeight * aspectRatio).round();
    }

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    canvas.drawImageRect(
      image,
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      Rect.fromLTWH(
        0,
        0,
        thumbnailWidth.toDouble(),
        thumbnailHeight.toDouble(),
      ),
      Paint(),
    );

    final picture = recorder.endRecording();
    final thumbnail = await picture.toImage(thumbnailWidth, thumbnailHeight);

    return imageToBase64(thumbnail);
  }

  static Future<Size> getImageSize(String base64String) async {
    final image = await base64ToImage(base64String);
    return Size(image.width.toDouble(), image.height.toDouble());
  }
}
