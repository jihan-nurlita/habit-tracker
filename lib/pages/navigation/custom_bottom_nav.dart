import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:habit_tracker/pages/calendar/calendar_page.dart';
import 'package:habit_tracker/pages/focus/focus_page.dart';
import 'package:habit_tracker/pages/habit/habit_page.dart';
import 'package:habit_tracker/pages/home/home_page.dart';
import 'package:habit_tracker/pages/profile/profile_page.dart';
import 'package:habit_tracker/providers/theme_provider.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).currentTheme;

    return BottomNavigationBar(
      currentIndex: currentIndex,
      elevation: 0,
      type: BottomNavigationBarType.fixed,
      backgroundColor: theme.cardColor,
      selectedItemColor: theme.primaryColor,
      unselectedItemColor: Colors.grey,
      selectedIconTheme: const IconThemeData(
        size: 28,
      ),
      showSelectedLabels: false,
      showUnselectedLabels: false,
      onTap: (index) {
        // Jika menekan halaman yang sedang aktif, tidak perlu navigasi ulang
        if (index == currentIndex) return;

        Widget targetPage;
        switch (index) {
          case 0:
            targetPage = const HomePage();
            break;
          case 1:
            targetPage = const HabitPage();
            break;
          case 2:
            targetPage = const FocusPage();
            break;
          case 3:
            targetPage = const CalendarPage();
            break;
          case 4:
            targetPage = const ProfilePage();
            break;
          default:
            return;
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => targetPage),
        );
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_rounded),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.task_alt_rounded),
          label: 'Habit',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.timer_outlined),
          label: 'Focus',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month_rounded),
          label: 'Calendar',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_rounded),
          label: 'Profile',
        ),
      ],
    );
  }
}
