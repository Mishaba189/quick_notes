import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_notes/providers/auth_provider.dart';
import 'package:quick_notes/providers/notes_provider.dart';
import 'package:provider/provider.dart';


class UpdateNote extends StatelessWidget {
  final String noteId;

  UpdateNote({
    super.key,
    required this.noteId,
  });

  @override
  Widget build(BuildContext context) {
    final upd = context.read<NoteProvider>();
    final auth = context.watch<AuthProvider>();
    final uid = auth.loggedInUserId;


    return Scaffold(
      appBar: AppBar( title:const Text('Edit'),),
      body: Padding(padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: upd.titleController,
            maxLines: 1,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              )
            ),
          ),
          TextField(
            controller: upd.contentController,
            maxLines: 5,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                )
            ),
          ),
          const SizedBox(height: 20,),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(onPressed: (){
              upd.updateNote(
                  uid!,
                  noteId,
                  upd.titleController.text.trim(),
                  upd.contentController.text.trim(),
              );
              Navigator.pop(context);
            },
                child:const Text('Update')
            ),
          )
        ],
      ),
      ),


    );
  }
}
