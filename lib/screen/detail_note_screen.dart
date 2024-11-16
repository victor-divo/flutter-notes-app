import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../model/database_helper.dart';
import '../model/note_model.dart';
import 'package:intl/intl.dart';

class DetailNoteScreen extends StatefulWidget {
  final int id; // The ID of the note to display

  const DetailNoteScreen({super.key, required this.id});

  @override
  DetailNoteScreenState createState() => DetailNoteScreenState();
}

class DetailNoteScreenState extends State<DetailNoteScreen> {
  Note? note; // The note to display
  bool isLoading = true; // Loading state to show progress indicator
  String errorMessage = ''; // Error message for failed data retrieval

  @override
  void initState() {
    super.initState();
    _fetchNoteData(); // Fetch the note data when the screen is initialized
  }

  // Fetch note data from the database by ID
  Future<void> _fetchNoteData() async {
    try {
      final fetchedNote = await DatabaseHelper.instance.getNoteById(widget.id);
      setState(() {
        note = fetchedNote;
        isLoading = false;
        if (fetchedNote == null) {
          errorMessage = 'No notes available'; // If no note is found
        }
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e'; // If there's an error fetching the note
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color customOrange = Colors.orange.shade700;

    // Helper function to format the date
    String formatDate(DateTime date) {
      return DateFormat('EEE, MMM d, yyyy - hh:mm a').format(date);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Notes',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: customOrange,
        elevation: 4,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            context.go('/'); // Go back to the home screen
          },
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator()) // Show loading indicator
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage)) // Show error message if any
              : note == null
                  ? const Center(
                      child: Text("No notes available")) // Handle no note case
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            note?.title ?? '',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: customOrange,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            note?.content ?? '',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 20),
                          Divider(color: Colors.grey.shade400),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Created At:",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  Text(
                                    formatDate(note!.createdAt),
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Updated At:",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  Text(
                                    formatDate(note!.updatedAt),
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: note != null
                                    ? () {
                                        context.push(
                                          '/edit-note/${note?.id ?? 0}',
                                          extra: {
                                            'title': note?.title ?? '',
                                            'content': note?.content ?? '',
                                          },
                                        ); // Navigate to EditNoteScreen
                                      }
                                    : null,
                                icon: const Icon(Icons.edit,
                                    size: 20, color: Colors.white),
                                label: const Text(
                                  "Edit Notes",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: customOrange,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
    );
  }
}
