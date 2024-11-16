import '../model/note_model.dart';

// Abstract base class for note states
abstract class NoteState {}

// Represents the loading state while notes are being fetched
class NotesLoading extends NoteState {}

// Represents the state when notes have been successfully loaded
class NotesLoaded extends NoteState {
  final List<Note> notes;
  NotesLoaded(this.notes); // Constructor to initialize the loaded notes
}

// Represents the state when an error occurs while fetching notes
class NotesError extends NoteState {
  final String error;
  NotesError(this.error); // Constructor to initialize the error message
}
