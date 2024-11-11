import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/note_viewmodel.dart';
import 'note_editor_screen.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Notes')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
              },
            ),
          ),
          Expanded(
            child: Consumer<NoteViewModel>(
              builder: (context, noteViewModel, child) {
                if (noteViewModel.notes.isEmpty) {
                  noteViewModel.fetchNotes();
                }

                final sortedNotes = List.of(noteViewModel.notes)
                  ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

                final filteredNotes = _searchQuery.isEmpty
                    ? sortedNotes
                    : sortedNotes
                        .where((note) => note.title
                            .toLowerCase()
                            .contains(_searchQuery.toLowerCase()))
                        .toList();

                return filteredNotes.isEmpty
                    ? Center(
                        child:
                            Text('No notes found. Start by adding a new note!'))
                    : GridView.builder(
                        padding: EdgeInsets.all(8.0),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                        ),
                        itemCount: filteredNotes.length,
                        itemBuilder: (context, index) {
                          final note = filteredNotes[index];
                          final noteDate =
                              DateFormat('dd/MM/yyyy').format(note.createdAt);

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      NoteEditorScreen(note: note),
                                ),
                              );
                            },
                            child: Card(
                              color: note.color != null
                                  ? Color(note.color)
                                  : Colors.purple[50],
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      note.title,
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 4.0),
                                    Text(
                                      noteDate,
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        color: const Color.fromARGB(255, 36, 35,
                                            35), // Set date color to white
                                      ),
                                    ),
                                    SizedBox(height: 8.0),
                                    Expanded(
                                      child: Text(
                                        note.content,
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NoteEditorScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
