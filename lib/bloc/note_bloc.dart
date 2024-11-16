import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'note_event.dart';
import 'note_state.dart';
import '../model/database_helper.dart';
import '../model/note_model.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final DatabaseHelper _databaseHelper;

  NoteBloc(this._databaseHelper) : super(NotesLoading()) {
    on<LoadNotes>(_onLoadNotes);
    on<AddNote>(_onAddNote);
    on<UpdateNote>(_onUpdateNote);
    on<DeleteNote>(_onDeleteNote);
  }

  // Helper function to load and emit notes
  Future<void> _loadAndEmitNotes(Emitter<NoteState> emit) async {
    try {
      final data = await _databaseHelper.readAllNotes();
      final notes = data.map((note) => Note.fromMap(note)).toList();
      debugPrint('Loaded notes: $notes');
      emit(NotesLoaded(notes));
    } catch (e) {
      emit(NotesError("Failed to load notes: $e"));
    }
  }

  // Event handler to load notes
  Future<void> _onLoadNotes(LoadNotes event, Emitter<NoteState> emit) async {
    log('Loading notes...');
    emit(NotesLoading());
    await _loadAndEmitNotes(emit);
  }

  // Event handler to add a new note
  Future<void> _onAddNote(AddNote event, Emitter<NoteState> emit) async {
    try {
      final newNote = event.note.copyWith(
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await _databaseHelper.create(newNote.toMap());
      debugPrint('Note added successfully');
      await _loadAndEmitNotes(emit);
    } catch (e) {
      emit(NotesError("Failed to add note: $e"));
    }
  }

  // Event handler to update an existing note
  Future<void> _onUpdateNote(UpdateNote event, Emitter<NoteState> emit) async {
    try {
      final updatedNote = event.note.copyWith(
        updatedAt: DateTime.now(),
      );
      await _databaseHelper.update(updatedNote.toMap());
      debugPrint('Note with ID ${event.note.id} updated successfully');
      await _loadAndEmitNotes(emit);
    } catch (e) {
      emit(NotesError("Failed to update note: $e"));
    }
  }

  // Event handler to delete a note
  Future<void> _onDeleteNote(DeleteNote event, Emitter<NoteState> emit) async {
    try {
      await _databaseHelper.delete(event.note.id ?? 0);
      debugPrint('Note with ID ${event.note.id} deleted successfully');
      await _loadAndEmitNotes(emit);
    } catch (e) {
      emit(NotesError("Failed to delete note: $e"));
    }
  }
}
