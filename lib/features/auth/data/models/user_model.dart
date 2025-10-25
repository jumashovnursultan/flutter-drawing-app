import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({required super.id, required super.email, super.name});

  factory UserModel.fromFirebaseUser(dynamic firebaseUser) {
    return UserModel(
      id: firebaseUser.uid as String,
      email: firebaseUser.email as String,
      name: firebaseUser.displayName,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(id: json['id'] as String, email: json['email'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'email': email};
  }

  UserModel copyWith({String? id, String? email}) {
    return UserModel(id: id ?? this.id, email: email ?? this.email);
  }
}
