import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'splash_screen.dart';
import 'home_screen.dart';
import 'lang_service.dart';
import 'lang_notifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LangService.load('en');
  runApp(
    ChangeNotifierProvider(
      create: (_) => LangNotifier.instance,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LangNotifier>(
      builder: (context, lang, child) {
        return MaterialApp(
          title: 'Stem Calculator',
          debugShowCheckedModeBanner: false,
          theme: ThemeData.dark(),
          home: const SplashScreen(),
          routes: {
            '/home': (context) => const HomeScreen(),
          },
        );
      },
    );
  }
}