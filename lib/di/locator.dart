import 'package:get_it/get_it.dart';
import '../model/database_helper.dart';
import '../bloc/note_bloc.dart';

final locator = GetIt.instance;

void setupLocator() {
  // Register DatabaseHelper as a singleton to be used throughout the app
  locator.registerLazySingleton(() => DatabaseHelper.instance);

  // Register NoteBloc with its dependency, DatabaseHelper
  locator.registerFactory(() => NoteBloc(locator<DatabaseHelper>()));
}
