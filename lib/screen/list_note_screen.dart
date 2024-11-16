import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/note_bloc.dart';
import '../bloc/note_event.dart';
import '../bloc/note_state.dart';
import 'package:go_router/go_router.dart';

class ListNoteScreen extends StatefulWidget {
  const ListNoteScreen({super.key});

  @override
  ListNoteScreenState createState() => ListNoteScreenState();
}

class ListNoteScreenState extends State<ListNoteScreen> {
  bool _isHovered = false; // To track hover state for the add button
  bool _isHoveredDelete = false; // To track hover state for delete icon

  @override
  Widget build(BuildContext context) {
    // Load notes when the screen is first displayed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NoteBloc>().add(LoadNotes());
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Note App',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.orange.shade600, // Soft orange color
        foregroundColor: Colors.white, // White text
        elevation: 4, // Elevation for shadow effect
        centerTitle: true, // Center the title
      ),
      floatingActionButton: MouseRegion(
        onEnter: (_) {
          // Add hover effect when mouse enters the floating button area
          setState(() {
            _isHovered = true;
          });
        },
        onExit: (_) {
          // Remove hover effect when mouse leaves
          setState(() {
            _isHovered = false;
          });
        },
        child: FloatingActionButton(
          onPressed: () {
            context.push('/add-note'); // Navigate to the add note screen
          },
          backgroundColor: _isHovered
              ? Colors.orange.shade900
              : Colors.orange.shade700, // Change color on hover
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
      body: BlocBuilder<NoteBloc, NoteState>(
        builder: (context, state) {
          if (state is NotesLoading) {
            return const Center(
                child: CircularProgressIndicator()); // Show loading indicator
          } else if (state is NotesLoaded) {
            final notes = state.notes;
            return notes.isEmpty
                ? const Center(
                    child: Text(
                        'No notes available')) // If no notes, show this message
                : ListView.separated(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      final note = notes[index];
                      return GestureDetector(
                        onTap: () {
                          context.push(
                            '/detail-note/${note.id}', // Navigate to detail page of the note
                            extra: {
                              'title': note.title,
                              'content': note.content
                            },
                          );
                        },
                        child: Card(
                          elevation: 6, // Strong shadow effect for the card
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12), // Rounded corners
                          ),
                          color: Colors.white,
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16.0),
                            title: Text(
                              note.title,
                              style: TextStyle(
                                fontSize: 20, // Larger title font size
                                fontWeight: FontWeight.bold,
                                color: Colors.orange.shade700,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  note.content.length > 30
                                      ? '${note.content.substring(0, 30)}...' // Show snippet of content
                                      : note.content,
                                  style: const TextStyle(
                                    fontSize: 16, // Smaller content text
                                    color: Colors.black54, // Lighter text color
                                  ),
                                ),
                                const SizedBox(
                                    height:
                                        8), // Space between content and date
                                Text(
                                  'Created at: ${DateFormat('dd MMM yyyy, hh:mm a').format(note.createdAt)}', // Formatted creation date
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                            trailing: MouseRegion(
                              onEnter: (_) {
                                setState(() {
                                  _isHoveredDelete =
                                      true; // Hover effect for delete button
                                });
                              },
                              onExit: (_) {
                                setState(() {
                                  _isHoveredDelete =
                                      false; // Remove hover effect
                                });
                              },
                              child: IconButton(
                                icon: const Icon(Icons.delete),
                                iconSize: 24,
                                onPressed: () {
                                  context.read<NoteBloc>().add(DeleteNote(
                                      note)); // Dispatch delete event
                                },
                                color: _isHoveredDelete
                                    ? Colors.orange.shade900
                                    : Colors.orange
                                        .shade700, // Change delete icon color on hover
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const Divider(), // Divider between notes
                  );
          } else if (state is NotesError) {
            return Center(
                child: Text('Error: ${state.error}')); // Show error message
          }
          return const Center(
              child: Text(
                  'No notes available')); // Default message if no state is matched
        },
      ),
    );
  }
}
