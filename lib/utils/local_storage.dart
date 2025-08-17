import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../features/auth/model/user_model.dart';

class LocalStorageService {
  static const String userKey = 'loggedInUser';

  Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(userKey, jsonEncode(user.toJson()));
  }

  Future<UserModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(userKey);
    print("Retrieved user JSON: $userJson"); // Check what's stored
    if (userJson == null) return null;
    final user = UserModel.fromJson(jsonDecode(userJson));
    print("Parsed user: ${user.fullName}, ${user.email}"); // Verify fields
    return user;
  }

  Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(userKey);
  }

  Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(LocalStorageService.userKey);
    if (jsonString == null) return null;

    final data = jsonDecode(jsonString);
    return data['fullName'] as String?;
  }


}
