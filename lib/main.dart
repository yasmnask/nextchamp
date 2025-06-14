import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nextchamp/pages/wrapper_page.dart';
import 'package:nextchamp/providers/user_provider.dart';
import 'package:nextchamp/providers/category_provider.dart';
import 'package:nextchamp/providers/course_provider.dart';
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
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => CourseProvider()),
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
      theme: ThemeData(fontFamily: 'Roboto'),
      home: const WrapperPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
