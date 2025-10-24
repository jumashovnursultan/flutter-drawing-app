import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/drawing.dart';

class DrawingModel extends Drawing {
  const DrawingModel({
    required super.id,
    required super.userId,
    required super.title,
    required super.imageData,
    required super.thumbnail,
    required super.author,
    required super.date,
  });

  factory DrawingModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return DrawingModel(
      id: doc.id,
      userId: data['userId'] as String,
      title: data['title'] as String,
      imageData: data['imageData'] as String,
      thumbnail: data['thumbnail'] as String,
      author: data['author'] as String,
      date: (data['date'] as Timestamp).toDate(),
    );
  }

  factory DrawingModel.fromJson(Map<String, dynamic> json) {
    return DrawingModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      imageData: json['imageData'] as String,
      thumbnail: json['thumbnail'] as String,
      author: json['author'] as String,
      date: DateTime.parse(json['date'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'title': title,
      'imageData': imageData,
      'thumbnail': thumbnail,
      'author': author,
      'date': Timestamp.fromDate(date),
    };
  }

  DrawingModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? imageData,
    String? thumbnail,
    String? author,
    DateTime? date,
  }) {
    return DrawingModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      imageData: imageData ?? this.imageData,
      thumbnail: thumbnail ?? this.thumbnail,
      author: author ?? this.author,
      date: date ?? this.date,
    );
  }
}
