import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_notes/providers/auth_provider.dart';
import 'package:quick_notes/providers/notes_provider.dart';

class AddNoteScreen extends StatelessWidget {
  const AddNoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final note = context.watch<NoteProvider>();
    final auth = context.watch<AuthProvider>();
    final uid = auth.loggedInUserId;
    return Scaffold(
      appBar: AppBar(title: const Text('Add Note')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller:note.titleController,
              maxLines: 1,
              decoration: InputDecoration(
                hintText: 'Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller:note.contentController,
              maxLines: 10,
              decoration: InputDecoration(
                hintText: 'Write your note...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: Consumer<NoteProvider>(
                builder: (context,noteProvider,child) {
                  return ElevatedButton(
                    onPressed: () async {
                      note.addNote(uid!);
                      Navigator.pop(context);
                    },
                    child: const Text('Save'),
                  );
                }
              ),
            ),
          ],
        ),
      ),
    );
  }
}
