import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:drawing_app/core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class ImageService {
  final ImagePicker _picker = ImagePicker();

  Future<ui.Image?> importFromGallery() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
      );

      if (pickedFile == null) return null;

      final bytes = await pickedFile.readAsBytes();
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      return frame.image;
    } catch (e) {
      throw Exception(AppStrings.importImageError(e.toString()));
    }
  }

  Future<void> shareImage(
    ui.Image image, {
    Rect? sharePositionOrigin, // для iPad
  }) async {
    try {
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        throw Exception(AppStrings.imageConversionFailed);
      }

      final bytes = byteData.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final file = File('${tempDir.path}/drawing_$timestamp.png');
      await file.writeAsBytes(bytes);

      await Share.shareXFiles(
        [XFile(file.path)],
        text: AppStrings.myDrawing,
        sharePositionOrigin: sharePositionOrigin,
      );
    } catch (e) {
      throw Exception(AppStrings.exportError(e.toString()));
    }
  }

  Future<void> saveToGallery(ui.Image image) async {
    try {
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        throw Exception(AppStrings.imageConversionFailed);
      }

      final Uint8List bytes = byteData.buffer.asUint8List();

      final result = await ImageGallerySaver.saveImage(
        bytes,
        quality: 100,
        name: 'drawing_${DateTime.now().millisecondsSinceEpoch}',
      );

      if (result['isSuccess'] != true) {
        throw Exception(AppStrings.saveToGalleryFailed);
      }
    } catch (e) {
      throw Exception(AppStrings.saveError(e.toString()));
    }
  }
}
