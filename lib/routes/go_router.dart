import 'package:go_router/go_router.dart';
import '../screen/list_note_screen.dart';
import '../screen/add_note_screen.dart';
import '../screen/detail_note_screen.dart';
import '../screen/edit_note_screen.dart';

class AppRouter {
  final GoRouter router = GoRouter(
    routes: [
      // Route to the list of notes screen
      GoRoute(
        path: '/',
        builder: (context, state) => const ListNoteScreen(),
      ),
      // Route to the add new note screen
      GoRoute(
        path: '/add-note',
        builder: (context, state) => const AddNoteScreen(),
      ),
      // Route to the detail view of a specific note
      GoRoute(
        path: '/detail-note/:id',
        builder: (context, state) {
          final id = int.tryParse(state.params['id']!) ?? 0;
          return DetailNoteScreen(id: id);
        },
      ),
      // Route to edit an existing note
      GoRoute(
        path: '/edit-note/:id',
        builder: (context, state) {
          final id = int.tryParse(state.params['id'] ?? '0') ?? 0;
          final title = state.queryParams['title'] ?? '';
          final content = state.queryParams['content'] ?? '';

          return EditNoteScreen(
            id: id,
            title: title,
            content: content,
          );
        },
      ),
    ],
  );
}
