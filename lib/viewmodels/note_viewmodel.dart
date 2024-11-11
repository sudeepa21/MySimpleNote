import 'package:flutter/material.dart';
import '../models/note.dart';
import '../services/database_service.dart';

class NoteViewModel extends ChangeNotifier {
  List<Note> _notes = [];
  final DatabaseService _dbService = DatabaseService.instance;

  List<Note> get notes => _notes;

  Future<void> fetchNotes() async {
    try {
      _notes = await _dbService.getNotes();
      notifyListeners();
    } catch (e) {
      print("Error fetching notes: $e");
    }
  }

  Future<void> addNote(Note note) async {
    await _dbService.addNote(note);
    await fetchNotes();
  }

  Future<void> deleteNoteById(int id) async {
    await _dbService.deleteNoteById(id);
    await fetchNotes();
  }

  Future<void> updateNote(Note note) async {
    await _dbService.updateNote(note);
    await fetchNotes();
  }
}
