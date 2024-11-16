import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/note_bloc.dart';
import '../bloc/note_event.dart';
import '../model/note_model.dart';
import 'package:go_router/go_router.dart';

class AddNoteScreen extends StatelessWidget {
  const AddNoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController titleController =
        TextEditingController(); // Controller for title input
    final TextEditingController contentController =
        TextEditingController(); // Controller for content input

    final Color customOrange =
        Colors.orange.shade700; // Custom orange color for styling

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Notes',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: customOrange, // Custom color for AppBar
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            context.go('/'); // Navigate back to the home screen
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4, // Card shadow effect
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(12), // Rounded corners for the card
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    // Title input field
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: 'Title',
                        labelStyle:
                            TextStyle(color: customOrange), // Label color
                        filled: true,
                        fillColor:
                            Colors.orange.shade50, // Light orange background
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              12), // Rounded corners for input field
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: customOrange), // Border color on focus
                        ),
                      ),
                    ),
                    const SizedBox(
                        height:
                            16.0), // Spacer between title and content fields
                    // Content input field
                    TextField(
                      controller: contentController,
                      maxLines: 5, // Allow multi-line input for content
                      decoration: InputDecoration(
                        labelText: 'Description',
                        labelStyle:
                            TextStyle(color: customOrange), // Label color
                        filled: true,
                        fillColor:
                            Colors.orange.shade50, // Light orange background
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              12), // Rounded corners for input field
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: customOrange), // Border color on focus
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
                height: 32.0), // Spacer between input fields and button
            // Save button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      10), // Rounded corners for the button
                ),
                backgroundColor: customOrange, // Custom color for the button
              ),
              onPressed: () {
                final title = titleController.text.trim(); // Get title text
                final content =
                    contentController.text.trim(); // Get content text

                if (title.isEmpty || content.isEmpty) {
                  // Show snack bar if title or content is empty
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Title and Description cannot be empty!'),
                      backgroundColor:
                          Colors.red, // Red background for error message
                      duration: Duration(seconds: 2),
                    ),
                  );
                } else {
                  // Create a new note if both title and content are provided
                  final note = Note(
                    title: title,
                    content: content,
                    createdAt: DateTime.now(), // Current date and time
                    updatedAt: DateTime.now(), // Current date and time
                  );

                  context
                      .read<NoteBloc>()
                      .add(AddNote(note)); // Dispatch AddNote event
                  context.pop(); // Navigate back to the previous screen
                }
              },
              child: const Text(
                'Save Notes',
                style: TextStyle(
                  color: Colors.white, // White text color
                  fontWeight: FontWeight.bold, // Bold text style
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
