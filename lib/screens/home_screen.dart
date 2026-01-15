import 'package:cloud_firestore/cloud_firestore.dart';
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
    final not = context.read<NoteProvider>();
    final uid = auth.loggedUid;
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
          )
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
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  onTap: (){
                    not.titleController.text = note['title'];
                    not.contentController.text = note['content'];

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => NoteScreen(noteId:note.id),
                      ),
                    );
                    not.disableEditing();

                  },
                  title: Text(note['title']),
                ),
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          not.clearControllers();
          Navigator.pushNamed(context, '/add');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
