import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drawing_app/core/constants/app_strings.dart';
import 'package:drawing_app/core/services/connectivity_service.dart';
import '../models/drawing_model.dart';

abstract class FirestoreDataSource {
  Future<DrawingModel> saveDrawing(DrawingModel drawing);
  Future<List<DrawingModel>> getDrawings(String userId);
  Future<DrawingModel> getDrawingById(String drawingId);
  Future<DrawingModel> updateDrawing(DrawingModel drawing);
  Future<void> deleteDrawing(String drawingId);
}

class FirestoreDataSourceImpl implements FirestoreDataSource {
  final FirebaseFirestore firestore;
  final InternetChecker internetChecker;

  static const String collectionName = 'drawings';

  FirestoreDataSourceImpl({
    required this.firestore,
    required this.internetChecker,
  });
  Future<void> _checkConnection() async {
    final hasInternet = await internetChecker.hasInternetAccess(); // ← ИЗМЕНИТЬ
    if (!hasInternet) {
      throw Exception(AppStrings.noInternet);
    }
  }

  @override
  Future<DrawingModel> saveDrawing(DrawingModel drawing) async {
    await _checkConnection();

    try {
      if (drawing.id.isNotEmpty) {
        final updateData = drawing.toJson();

        updateData.remove('id');

        await firestore
            .collection(collectionName)
            .doc(drawing.id)
            .update(updateData);

        print('✅ Рисунок обновлен: ${drawing.id}');

        final doc = await firestore
            .collection(collectionName)
            .doc(drawing.id)
            .get();

        return DrawingModel.fromFirestore(doc);
      } else {
        final newDrawing = drawing;

        final docRef = await firestore
            .collection(collectionName)
            .add(newDrawing.toJson());

        print('✅ Новый рисунок создан: ${docRef.id}');

        final doc = await docRef.get();
        return DrawingModel.fromFirestore(doc);
      }
    } catch (e) {
      print('❌ Ошибка сохранения: $e');
      throw Exception(AppStrings.saveDrawingError(e.toString()));
    }
  }

  @override
  Future<List<DrawingModel>> getDrawings(String userId) async {
    await _checkConnection();
    try {
      final querySnapshot = await firestore
          .collection(collectionName)
          .where('userId', isEqualTo: userId)
          .orderBy('date', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => DrawingModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception(AppStrings.loadDrawingsError);
    }
  }

  @override
  Future<DrawingModel> getDrawingById(String drawingId) async {
    await _checkConnection();
    try {
      final doc = await firestore
          .collection(collectionName)
          .doc(drawingId)
          .get();

      if (!doc.exists) {
        throw Exception(AppStrings.drawingNotFound);
      }

      return DrawingModel.fromFirestore(doc);
    } catch (e) {
      throw Exception(AppStrings.loadDrawingError(e.toString()));
    }
  }

  @override
  Future<DrawingModel> updateDrawing(DrawingModel drawing) async {
    await _checkConnection();
    try {
      await firestore.collection(collectionName).doc(drawing.id).update({
        'imageData': drawing.imageData,
        'thumbnail': drawing.thumbnail,
        'date': Timestamp.fromDate(drawing.date),
      });

      final doc = await firestore
          .collection(collectionName)
          .doc(drawing.id)
          .get();
      return DrawingModel.fromFirestore(doc);
    } catch (e) {
      throw Exception(AppStrings.updateDrawingError(e.toString()));
    }
  }

  @override
  Future<void> deleteDrawing(String drawingId) async {
    await _checkConnection();
    try {
      await firestore.collection(collectionName).doc(drawingId).delete();
    } catch (e) {
      throw Exception(AppStrings.deleteDrawingError(e.toString()));
    }
  }
}
