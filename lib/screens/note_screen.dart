import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_notes/providers/auth_provider.dart';
import 'package:quick_notes/providers/notes_provider.dart';

class NoteScreen extends StatelessWidget {
  final String noteId;

  const NoteScreen({
    super.key,
    required this.noteId,
  });

  @override
  Widget build(BuildContext context) {
    final upd = context.watch<NoteProvider>();
    final auth = context.watch<AuthProvider>();
    final uid = auth.firestoreUserId;

    return Scaffold(
      appBar: AppBar(
        // title: const Text('Note'),
        actions: [
          TextButton(onPressed: (){
            upd.enableEditing();
          },
              child: Text('Edit',
                style: TextStyle(color:Colors.green ),)),
          TextButton(onPressed: (){
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Delete Note'),
                  content: const Text(
                    'Are you sure you want to delete this Note?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () {
                        upd.deleteNotes(uid!,noteId);
                        Navigator.pushNamed(context, '/home');


                      },
                      child: const Text('Delete',style: TextStyle(color: Colors.white),),
                    ),
                  ],

                );
              }
            );


          },
              child: Text('Delete',
                style: TextStyle(color:Colors.red ),)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: upd.titleController,
              readOnly: !upd.isEditing,
              enableInteractiveSelection: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: upd.contentController,
              readOnly: !upd.isEditing,
              enableInteractiveSelection: true,
              maxLines: 10,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: upd.isEditing
                    ? () {
                  upd.updateNote(
                    uid!,
                    noteId,
                    upd.titleController.text.trim(),
                    upd.contentController.text.trim(),
                  );
                  upd.disableEditing();
                  Navigator.pop(context);
                }
                    : null,
                child: const Text('Save'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
