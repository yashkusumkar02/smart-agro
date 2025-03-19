import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveUserData(String uid, String email) async {
    await _db.collection('users').doc(uid).set({
      'email': email,
      'createdAt': DateTime.now(),
    });
  }

  Future<List<Map<String, dynamic>>> getCommunityPosts() async {
    QuerySnapshot snapshot = await _db.collection('community').get();
    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }
}
