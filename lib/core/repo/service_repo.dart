import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ServiceRequestRepository {
  final _db = FirebaseDatabase.instance.ref();
  final _storage = FirebaseStorage.instance;

  Future<String> submitServiceRequest({
    required String fullName,
    required String location,
    required String phone,
    required String email,
    required String service,
    File? attachment,
  }) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    // Pre-create RTDB node to get a requestId
    final reqRef = _db.child('users/$uid/service_requests').push();
    final requestId = reqRef.key!;

    // Optional: upload image and get URL
    String? imageUrl;
    if (attachment != null) {
      final storageRef =
          _storage.ref().child('service_requests/$uid/$requestId.jpg');
      await storageRef.putFile(attachment);
      imageUrl = await storageRef.getDownloadURL();
    }

    // Save to RTDB
    await reqRef.set({
      'requestId': requestId,
      'service': service,
      'fullName': fullName,
      'location': location,
      'phone': phone,
      'email': email,
      'imageUrl': imageUrl ?? '',
      'status': 'submitted', // submitted -> in_progress -> completed
      'createdAt': ServerValue.timestamp,
    });

    return requestId;
  }
}
