
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../core/repo/user_repo.dart';
import '../../../core/services/user_services.dart';
import '../../../utils/local_storage.dart';
import '../model/user_model.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService;
  final UserRepository _userRepo;
  final LocalStorageService _localStorage = LocalStorageService();
    ValueListenable<UserModel?> get localUser => _localStorage.user;
  bool isLoading = false;
  String? error;
User? get currentUser => FirebaseAuth.instance.currentUser;
  AuthViewModel(this._authService, this._userRepo);

  /// Format Firebase errors into friendly text
  String _mapFirebaseError(String code) {
    switch (code) {
      case 'invalid-email':
        return "The email address format is invalid.";
      case 'email-already-in-use':
        return "An account already exists for this email.";
      case 'weak-password':
        return "Password must be at least 6 characters.";
      case 'user-not-found':
        return "No user found for this email.";
      case 'wrong-password':
        return "Incorrect password. Try again.";
      case 'too-many-requests':
        return "Too many attempts. Try again later.";
      case 'network-request-failed':
        return "No internet connection. Please try again.";
      default:
        return "An unexpected error occurred. Please try again.";
    }
  }

Future<void> signUp(UserModel user, String password) async {
  isLoading = true;
  error = null;
  notifyListeners();

  try {
    final result = await _authService.signUp(user.email, password);
    final uid = result.user?.uid;
    if (uid == null || uid.isEmpty) {
      throw StateError('Firebase returned empty uid');
    }

    final userWithUid = user.copyWith(uid: uid);
    debugPrint("Signup Firebase Success: UID = $uid");

    await _userRepo.createUser(userWithUid);
    await _localStorage.saveUser(userWithUid);

    error = null;
  } on FirebaseAuthException catch (e) {
    debugPrint("FirebaseAuthException: ${e.code} - ${e.message}");
    error = _mapFirebaseError(e.code);
  } on FirebaseException catch (e) {
    error = e.message ?? 'Database error';
  } catch (e) {
    debugPrint("General signup error: $e");
    error = "Something went wrong. Try again.";
  } finally {
    isLoading = false;
    notifyListeners();
  }
}

Future<void> login(String email, String password) async {
  isLoading = true;
  error = null;
  notifyListeners();

  try {
    await _authService.login(email, password);
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) throw StateError('No current user after login');

    // Prefer by uid
    UserModel? user = await _userRepo.getUserByUid(uid);

    // (Optional) backward-compat for old email-keyed records:
    // if (user == null) user = await _userRepo.getUserByEmail(email);

    if (user != null) {
      await _localStorage.saveUser(user);
    } else {
      // Optionally create a minimal user record if missing
      // await _userRepo.createUser(UserModel(uid: uid, fullName: '', email: email));
    }
    error = null;
  } on FirebaseAuthException catch (e) {
    error = _mapFirebaseError(e.code);
  } catch (e) {
    error = "Something went wrong. Please try again.";
  } finally {
    isLoading = false;
    notifyListeners();
  }
}

 Future<void> signInWithGoogle() async {
  isLoading = true;
  error = null;
  notifyListeners();

  try {
    final result = await _authService.signInWithGoogle();
    if (result == null) {
      error = "Google login cancelled.";
      return;
    }

    final uid = result.user!.uid;
    final email = result.user!.email!;
    final fullName = result.user!.displayName ?? 'Google User';

    var user = await _userRepo.getUserByUid(uid);
    if (user == null) {
      user = UserModel(uid: uid, fullName: fullName, email: email);
      await _userRepo.createUser(user);
    }
    await _localStorage.saveUser(user);
    error = null;
  } on FirebaseAuthException catch (e) {
    error = _mapFirebaseError(e.code);
  } catch (e) {
    debugPrint("Google Sign-In Error: $e");
    error = "Google login failed. Please try again.";
  } finally {
    isLoading = false;
    notifyListeners();
  }
}

  Future<void> resetPassword(String email) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      await _authService.sendResetPassword(email);
      // Optionally, show a success snackbar or message
    } on FirebaseAuthException catch (e) {
      error = _mapFirebaseError(e.code);
    } catch (_) {
      error = "Failed to send password reset email. Try again.";
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    isLoading = true;
    notifyListeners();

    try {
      await _authService.signOut();
      await _localStorage.clearUser(); // clear locally stored user
      error = null;
    } catch (e) {
      error = "Logout failed. Try again.";
    }

    isLoading = false;
    notifyListeners();
  }
}
