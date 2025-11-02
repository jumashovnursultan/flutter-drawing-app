import 'dart:io';

import 'dart:ui' as ui;
import 'package:drawing_app/core/constants/app_strings.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

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

  Future<void> shareImage(ui.Image image) async {
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

      await Share.shareXFiles([XFile(file.path)], text: AppStrings.myDrawing);
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

      final bytes = byteData.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final file = File('${tempDir.path}/drawing_$timestamp.png');
      await file.writeAsBytes(bytes);

      await Share.shareXFiles([
        XFile(file.path),
      ], text: AppStrings.saveToPhotos);
    } catch (e) {
      throw Exception(AppStrings.saveError(e.toString()));
    }
  }
}
