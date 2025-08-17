// core/models/user_model.dart
class UserModel {
  final String uid;
  final String fullName;
  final String email;
  final String? photoUrl;
  final String? location;

  UserModel({
    required this.uid,
    required this.fullName,
    required this.email,
    this.photoUrl,
    this.location,
  });

  UserModel copyWith({
    String? fullName,
    String? email,
    String? photoUrl,
    String? location, required String uid,
  }) {
    return UserModel(
      uid: uid,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      location: location ?? this.location,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        uid: json['uid'],
        fullName: json['fullName'],
        email: json['email'],
        photoUrl: json['photoUrl'],
        location: json['location'],
      );

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'fullName': fullName,
        'email': email,
        'photoUrl': photoUrl,
        'location': location,
      };
}
