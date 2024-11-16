import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/note_bloc.dart';
import '../bloc/note_event.dart';
import '../model/note_model.dart';

class EditNoteScreen extends StatefulWidget {
  final int? id;
  final String? title;
  final String? content;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const EditNoteScreen({
    super.key,
    this.id,
    this.title,
    this.content,
    this.createdAt,
    this.updatedAt,
  });

  @override
  EditNoteScreenState createState() => EditNoteScreenState();
}

class EditNoteScreenState extends State<EditNoteScreen> {
  // Variables to store note data and controllers for text fields
  Note? _note;
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    // Initializing controllers for title and content input
    _titleController = TextEditingController();
    _contentController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Fetching the note data passed from the previous screen using GoRouter
    final noteData = GoRouter.of(context)
        .routerDelegate
        .currentConfiguration
        .extra as Map<String, String>?;

    // Initializing the note object with the data (from parameters or GoRouter)
    _note = Note(
      id: widget.id,
      title: noteData?['title'] ?? widget.title ?? '',
      content: noteData?['content'] ?? widget.content ?? '',
      createdAt: widget.createdAt ?? DateTime.now(),
      updatedAt: widget.updatedAt,
    );

    // Updating the controllers with the note's current data
    _titleController.text = _note?.title ?? '';
    _contentController.text = _note?.content ?? '';
  }

  @override
  void dispose() {
    // Disposing controllers when no longer needed
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Define custom colors for the app theme
    final Color customOrange = Colors.orange.shade700;
    final Color darkOrange = Colors.orange.shade900;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          // Set title based on whether it's an edit or add action
          _note?.id == null ? 'Add Notes' : 'Edit Notes',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: customOrange,
        elevation: 4,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            context.pop(); // Go back to the previous screen
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    // Title input field
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: 'Title',
                        labelStyle: TextStyle(color: customOrange),
                        filled: true,
                        fillColor: Colors.orange.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: customOrange),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Content input field
                    TextField(
                      controller: _contentController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        labelStyle: TextStyle(color: customOrange),
                        filled: true,
                        fillColor: Colors.orange.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: customOrange),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Display creation and update dates if note exists
                    if (_note != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Created on: ${_note!.formattedCreatedAt}',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Last updated: ${_note!.formattedUpdatedAt}',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            // Save or Update Button
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.pressed)) {
                    return darkOrange;
                  }
                  return customOrange;
                }),
                foregroundColor: WidgetStateProperty.all(Colors.white),
                overlayColor:
                    WidgetStateProperty.all(Colors.orange.withOpacity(0.1)),
                padding: WidgetStateProperty.all(
                  const EdgeInsets.symmetric(vertical: 16.0),
                ),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                elevation: WidgetStateProperty.resolveWith((states) {
                  return states.contains(WidgetState.pressed) ? 2 : 4;
                }),
              ),
              onPressed: _saveNote, // Call save or update function
              child: Text(
                _note?.id == null ? 'Add Notes' : 'Update Notes',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to handle saving or updating the note
  void _saveNote() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    // Show an error if either title or content is empty
    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Title and Description cannot be empty!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Create or update the note
    final updatedNote = Note(
      id: _note?.id, // Keep the same ID if updating
      title: title,
      content: content,
      createdAt:
          _note?.createdAt ?? DateTime.now(), // Keep existing creation date
      updatedAt: DateTime.now(), // Set updated time
    );

    // Dispatch the appropriate event to the Bloc
    if (updatedNote.id == null) {
      // Add a new note
      BlocProvider.of<NoteBloc>(context).add(AddNote(updatedNote));
    } else {
      // Update the existing note
      BlocProvider.of<NoteBloc>(context).add(UpdateNote(updatedNote));
    }

    // After saving, pop the screen and navigate to the note's detail page
    context.pop(); // Close the Edit screen
    context.go(
      '/detail-note/${updatedNote.id}', // Navigate to the detail screen
      extra: updatedNote, // Pass the updated note data
    );
  }
}
