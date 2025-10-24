class FirebaseConstants {
  // Collections
  static const String usersCollection = 'users';
  static const String drawingsCollection = 'drawings';

  // Fields - User
  static const String userIdField = 'userId';
  static const String emailField = 'email';
  static const String createdAtField = 'createdAt';

  // Fields - Drawing
  static const String drawingIdField = 'id';
  static const String titleField = 'title';
  static const String imageDataField = 'imageData'; // Base64 строка
  static const String authorField = 'author';
  static const String dateField = 'date';
  static const String thumbnailField = 'thumbnail'; // Превью изображения
}
