import 'package:flutter/material.dart';
import 'package:habit_tracker/pages/auth/login_page.dart';
import 'package:habit_tracker/pages/auth/providers/auth_provider.dart';
import 'package:habit_tracker/pages/home/home_page.dart';
import 'package:habit_tracker/providers/focus_provider.dart';
import 'package:habit_tracker/providers/habit_provider.dart';
import 'package:habit_tracker/providers/theme_provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

void main() async {
  /// wajib
  WidgetsFlutterBinding.ensureInitialized();

  /// initialize bahasa indonesia
  await initializeDateFormatting(
    'id_ID',
    null,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider()..loadUser(),
        ),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => HabitProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => FocusProvider(),
        ),
      ],
      child: const HabitTracker(),
    ),
  );
}

class HabitTracker extends StatelessWidget {
  const HabitTracker({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Habit Tracker',
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
      },
      home: const HomePage(),
    );
  }
}
