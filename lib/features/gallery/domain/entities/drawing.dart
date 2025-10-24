import 'package:equatable/equatable.dart';

class Drawing extends Equatable {
  final String id;
  final String userId;
  final String title;
  final String imageData;
  final String thumbnail;
  final String author;
  final DateTime date;

  const Drawing({
    required this.id,
    required this.userId,
    required this.title,
    required this.imageData,
    required this.thumbnail,
    required this.author,
    required this.date,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    title,
    imageData,
    thumbnail,
    author,
    date,
  ];
}
