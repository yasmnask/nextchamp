import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nextchamp/pages/wrapper_page.dart';
import 'package:nextchamp/providers/app_state_provider.dart';
import 'package:nextchamp/providers/bottom_navigation_provider.dart';
import 'package:nextchamp/providers/mentor_provider.dart';
import 'package:nextchamp/providers/user_provider.dart';
import 'package:nextchamp/providers/category_provider.dart';
import 'package:nextchamp/providers/course_provider.dart';
import 'package:nextchamp/services/chat_service.dart';
import 'package:nextchamp/services/gemini_service.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    print('FlutterError: ${details.exceptionAsString()}');
  };

  await dotenv.load(fileName: ".env").catchError((e) {
    print('Env file not found, using defaults');
  });
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BottomNavigationProvider()),
        ChangeNotifierProvider(create: (_) => AppStateProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => CourseProvider()),
        ChangeNotifierProvider(create: (_) => MentorProvider()),
        Provider(create: (_) => GeminiService()),
        Provider(create: (_) => ChatService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NextChamp',
      theme: ThemeData(
        fontFamily: 'Roboto',
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF1E293B)),
      ),
      home: const WrapperPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
