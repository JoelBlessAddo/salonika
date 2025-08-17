// core/repo/user_repo.dart
import 'package:firebase_database/firebase_database.dart';
import '../../features/auth/model/user_model.dart';
import 'package:flutter/foundation.dart';

class UserRepository extends ChangeNotifier {
  final FirebaseDatabase _db;
  UserRepository({FirebaseDatabase? db}) : _db = db ?? FirebaseDatabase.instance;

  DatabaseReference get _usersRef => _db.ref('users');

  Future<void> createUser(UserModel user) async {
    if (user.uid.isEmpty) {
      throw ArgumentError('User uid is empty; cannot write to /users/{uid}');
    }
    await _usersRef.child(user.uid).set({
      'uid': user.uid,
      'fullName': user.fullName,
      'email': user.email,
      'createdAt': ServerValue.timestamp,
    });
  }

  Future<UserModel?> getUserByUid(String uid) async {
    final snap = await _usersRef.child(uid).get();
    if (!snap.exists) return null;
    return UserModel.fromJson(Map<String, dynamic>.from(snap.value as Map));
  }

  // Optional: query by email (requires .indexOn ["email"] in rules)
  Future<UserModel?> getUserByEmail(String email) async {
    final q = _usersRef.orderByChild('email').equalTo(email);
    final snap = await q.get();
    if (!snap.exists) return null;
    final first = (snap.value as Map).values.first;
    return UserModel.fromJson(Map<String, dynamic>.from(first));
  }

  Future<List<UserModel>> getAllUsers() async {
    final snap = await _usersRef.get();
    if (!snap.exists) return <UserModel>[];
    final data = Map<String, dynamic>.from(snap.value as Map);
    return data.values
        .map((e) => UserModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}
