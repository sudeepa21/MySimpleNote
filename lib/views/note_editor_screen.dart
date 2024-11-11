import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/note_viewmodel.dart';
import '../models/note.dart';

class NoteEditorScreen extends StatefulWidget {
  final Note? note;

  NoteEditorScreen({this.note});

  @override
  _NoteEditorScreenState createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  int _noteColor = Colors.green.value;

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
      _noteColor = widget.note!.color;
    }
  }

  Future<void> _showDeleteConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Note'),
          content: Text('Do you want to delete this note?'),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () async {
                final noteViewModel =
                    Provider.of<NoteViewModel>(context, listen: false);
                await noteViewModel.deleteNoteById(widget.note!.id!);
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pop(); // Close the editor screen
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'New Note' : 'Edit Note'),
        actions: [
          if (widget.note != null)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _showDeleteConfirmationDialog(context);
              },
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(labelText: 'Content'),
              maxLines: 5,
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildColorPicker(Colors.green),
                _buildColorPicker(Colors.red),
                _buildColorPicker(Colors.blue),
                _buildColorPicker(Colors.yellow),
              ],
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () async {
                if (_titleController.text.isEmpty ||
                    _contentController.text.isEmpty) return;

                final noteViewModel =
                    Provider.of<NoteViewModel>(context, listen: false);
                final newNote = Note(
                  id: widget.note?.id,
                  title: _titleController.text,
                  content: _contentController.text,
                  createdAt: widget.note?.createdAt ?? DateTime.now(),
                  color: _noteColor,
                );

                if (widget.note == null) {
                  await noteViewModel.addNote(newNote); // Add new note
                } else {
                  await noteViewModel
                      .updateNote(newNote); // Update existing note
                }

                Navigator.of(context).pop();
              },
              child: Text('Save Note'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorPicker(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _noteColor = color.value;
        });
      },
      child: CircleAvatar(
        backgroundColor: color,
        child: _noteColor == color.value
            ? Icon(Icons.check, color: Colors.white)
            : null,
      ),
    );
  }
}
