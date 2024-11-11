import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/note_viewmodel.dart';
import 'views/home_screen.dart'; // Corrected import path

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // Ensure MultiProvider is used correctly
      providers: [
        ChangeNotifierProvider(
            create: (_) => NoteViewModel()), // Correct ChangeNotifierProvider
      ],
      child: MaterialApp(
        title: 'Colorful Note App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomeScreen(), // Use HomeScreen instead of Home
      ),
    );
  }
}
