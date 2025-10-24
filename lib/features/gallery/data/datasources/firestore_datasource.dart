import 'package:cloud_firestore/cloud_firestore.dart';
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
  static const String collectionName = 'drawings';

  FirestoreDataSourceImpl({required this.firestore});

  @override
  Future<DrawingModel> saveDrawing(DrawingModel drawing) async {
    try {
      final docRef = await firestore
          .collection(collectionName)
          .add(drawing.toJson());

      final doc = await docRef.get();
      return DrawingModel.fromFirestore(doc);
    } catch (e) {
      throw Exception('Ошибка сохранения рисунка: $e');
    }
  }

  @override
  Future<List<DrawingModel>> getDrawings(String userId) async {
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
      throw Exception('Ошибка загрузки рисунков: $e');
    }
  }

  @override
  Future<DrawingModel> getDrawingById(String drawingId) async {
    try {
      final doc = await firestore
          .collection(collectionName)
          .doc(drawingId)
          .get();

      if (!doc.exists) {
        throw Exception('Рисунок не найден');
      }

      return DrawingModel.fromFirestore(doc);
    } catch (e) {
      throw Exception('Ошибка загрузки рисунка: $e');
    }
  }

  @override
  Future<DrawingModel> updateDrawing(DrawingModel drawing) async {
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
      throw Exception('Ошибка обновления рисунка: $e');
    }
  }

  @override
  Future<void> deleteDrawing(String drawingId) async {
    try {
      await firestore.collection(collectionName).doc(drawingId).delete();
    } catch (e) {
      throw Exception('Ошибка удаления рисунка: $e');
    }
  }
}
