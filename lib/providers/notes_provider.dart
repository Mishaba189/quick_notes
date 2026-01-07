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





}