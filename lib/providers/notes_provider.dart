import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';


class NoteProvider extends ChangeNotifier{
  final FirebaseFirestore firestore= FirebaseFirestore.instance;
  //controllers
  final contentController = TextEditingController();
  final titleController= TextEditingController();

  //add note

  Future<void> addNote(String uid) async {
    final title = titleController.text.trim();
    final content = contentController.text.trim();
    final noteID =  DateTime.now().millisecondsSinceEpoch.toString();
    final createdAt = FieldValue.serverTimestamp();
    final updatedAt = FieldValue.serverTimestamp();

    try {

      await firestore
          .collection('users')
          .doc(uid)
          .collection('Notes')
          .doc(noteID)
          .set({
        'title':title,
        'content': content,
        'createdAt': createdAt,
        'updatedAT': updatedAt
      });

      titleController.clear();
      contentController.clear();

      notifyListeners();
    } catch (e) {
      debugPrint('Error adding note: $e');
    }
  }

  // fetch note

  Stream<QuerySnapshot> fetchNotes(String uid){
    return firestore
        .collection('users')
        .doc(uid)
        .collection('Notes')
        .orderBy('createdAt' , descending: true)
        .snapshots();
  }

  //delete note

  Future<void>deleteNotes(String uid,String noteID) async{
    return firestore
        .collection('users')
        .doc(uid)
        .collection('Notes')
        .doc(noteID)
        .delete();
  }

  //update note

  Future<void>updateNote(String uid,String noteID,String title, String content)async{
    final updatedAt = FieldValue.serverTimestamp();
    return firestore
        .collection('users')
        .doc(uid)
        .collection('Notes')
        .doc(noteID)
        .update({
      'title' : title,
      'content' : content,
      'updatedAt' : updatedAt
    });
  }


  void clearControllers() {
    titleController.clear();
    contentController.clear();
  }




}