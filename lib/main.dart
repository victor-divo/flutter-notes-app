import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:universal_platform/universal_platform.dart';
import 'di/locator.dart';
import 'routes/go_router.dart';
import 'package:provider/provider.dart';
import 'bloc/note_bloc.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  // Initialize sqflite for desktop and web platforms
  if (UniversalPlatform.isWindows ||
      UniversalPlatform.isLinux ||
      UniversalPlatform.isMacOS) {
    sqfliteFfiInit(); // For desktop
  }

  // Set the appropriate database depending on the platform
  if (kIsWeb) {
    log('Running on Web');
    databaseFactory = databaseFactoryFfiWeb; // For web
  } else {
    databaseFactory =
        databaseFactoryFfi; // For mobile and other desktop platforms
  }

  setupLocator(); // Initialize GetIt (dependency injection)
  runApp(const NoteApp());
}

class NoteApp extends StatelessWidget {
  const NoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Use Provider to inject the NoteBloc using GetIt
        Provider<NoteBloc>(
          create: (_) => locator<NoteBloc>(),
          dispose: (_, bloc) =>
              bloc.close(), // Make sure to close the bloc when done
        ),
      ],
      child: MaterialApp.router(
        // Use the configured router with GoRouter
        routerConfig: AppRouter().router,
        debugShowCheckedModeBanner: false, // Remove the debug banner
      ),
    );
  }
}
