import 'package:cloud_firestore/cloud_firestore.dart';

class UserFirestoreServices {
  final CollectionReference users =
  FirebaseFirestore.instance.collection('users');

//add
  Future<String> createUser({
    required String authUid,
    required String name,
    required String email,
  }) async {
    final docId = DateTime.now().millisecondsSinceEpoch.toString();

    await users.doc(docId).set({
      'authUid': authUid,
      'name': name,
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
    });

    return docId;
  }


//fetch
  Stream<QuerySnapshot> getUsers() {
    return users.snapshots();
  }
//update
  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await users.doc(uid).update(data);
  }
//delete
  Future<void> deleteUser(String uid) async {
    await users.doc(uid).delete();
  }
}