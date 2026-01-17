import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_notes/providers/auth_provider.dart';
import 'package:quick_notes/providers/notes_provider.dart';
import 'package:quick_notes/screens/note_screen.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final not = context.watch<NoteProvider>();
    final uid = auth.firestoreUserId;
    return Scaffold(
      appBar: AppBar(
        leading: not.isSelecting ? IconButton(
            onPressed: (){
              not.clearSelection();
            },
            icon:Icon(Icons.arrow_back)): null,
        title:  not.isSelecting
            ? Text('${not.selectedNoteIds.length} selected')
            : const Text('My Notes'),
        actions: [
          not.isSelecting
              ? IconButton(
            onPressed: () {
              not.deleteSelectedNotes(uid!);
              not.clearSelection();
            },
            icon: const Icon(CupertinoIcons.delete,color: Colors.red,)
          )
              : IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              auth.logout();
              Navigator.pushNamed(context, '/login');
            },
          ),
        ],

        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: uid == null ? null : not.fetchNotes(uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No notes yet'));
          }

          final notes = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];

              return Card(
                color: not.selectedNoteIds.contains(note.id)
                    ? Color(0x20FFCC9D)
                    : null,
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  onTap:(){
                    if(not.isSelecting){
                      not.toggleSelection(note.id);
                    } else {
                    not.titleController.text = note['title'];
                    not.contentController.text = note['content'];

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => NoteScreen(noteId:note.id),
                      ),
                    );
                    not.disableEditing();}

                  },
                  onLongPress: (){
                   not.toggleSelection(note.id);
                  },
                  title: Text(note['title']),
                ),
              );
            },
          );
        },
      ),

      floatingActionButton:not.isSelecting? null : FloatingActionButton(
        onPressed: () {
          not.clearControllers();
          Navigator.pushNamed(context, '/add');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
