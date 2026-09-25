import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:habit_tracker/pages/auth/providers/auth_provider.dart';
import 'package:habit_tracker/pages/calendar/calendar_page.dart';
import 'package:habit_tracker/pages/focus/focus_page.dart';
import 'package:habit_tracker/pages/habit/habit_page.dart';
import 'package:habit_tracker/pages/profile/profile_page.dart';
import 'package:habit_tracker/providers/focus_provider.dart';
import 'package:habit_tracker/providers/habit_provider.dart';
import 'package:habit_tracker/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final habitProvider = Provider.of<HabitProvider>(context);
    final focusProvider = Provider.of<FocusProvider>(context);
    final theme = Provider.of<ThemeProvider>(context).currentTheme;
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: theme.backgroundColor,

      /// =========================
      /// BOTTOM NAVBAR
      /// =========================
      bottomNavigationBar: const _BottomNavbar(currentIndex: 0),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// =========================
              /// HEADER
              /// =========================
              Row(
                children: [
                  /// Avatar
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: theme.softColor,
                    child: Text(
                      auth.name.isNotEmpty ? auth.name[0].toUpperCase() : "U",
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: theme.primaryColor,
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  /// Greeting
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Selamat Pagi,",
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: theme.iconColor.withOpacity(0.7),
                          ),
                        ),
                        Text(
                          auth.name.isNotEmpty ? auth.name : "Amelia azzahra",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: theme.textColor,
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// Notification
                  Icon(
                    Icons.notifications_none_rounded,
                    color: theme.iconColor,
                    size: 28,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Text(
                "Timeline Hari Ini",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.textColor,
                ),
              ),

              const SizedBox(height: 16),

              /// =========================
              /// TIMELINE CONTENT (PROGRESS & LIST HABIT)
              /// =========================
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// SISI KIRI: Garis Timeline Vertikal
                  Column(
                    children: [
                      // Titik paling atas di dekat Progress Card
                      Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: theme.primaryColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Container(
                        width: 2,
                        height: 55,
                        color: theme.softColor,
                      ),
                      // Loop titik & jam timeline mengikuti jumlah data habit secara dinamis
                      ...List.generate(habitProvider.habits.length, (index) {
                        final habit = habitProvider.habits[index];
                        return Column(
                          children: [
                            Text(
                              habit.startTime.isNotEmpty
                                  ? habit.startTime
                                  : "08:00",
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: theme.textColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: theme.primaryColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            Container(
                              width: 2,
                              height: 85,
                              color: theme.softColor,
                            ),
                          ],
                        );
                      }),
                    ],
                  ),

                  const SizedBox(width: 16),

                  /// SISI KANAN: Progress Card & List Card
                  Expanded(
                    child: Column(
                      children: [
                        /// =========================
                        /// HERO PROGRESS CARD
                        /// =========================
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 16),
                          decoration: BoxDecoration(
                            color: theme.softColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Progress",
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: theme.textColor.withOpacity(0.7),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    "${(habitProvider.progressPercent * 100).toInt()}%",
                                    style: GoogleFonts.poppins(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: theme.textColor,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    "${habitProvider.completedHabits}/${habitProvider.totalHabits} Habit",
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      color: theme.textColor.withOpacity(0.7),
                                    ),
                                  ),
                                  const Spacer(),
                                  // Horizontal Progress Bar Mini
                                  Container(
                                    width: 60,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: theme.borderColor,
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                    child: FractionallySizedBox(
                                      alignment: Alignment.centerLeft,
                                      widthFactor:
                                          habitProvider.progressPercent,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: theme.primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(3),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        /// =========================
                        /// HABIT LIST VIEW
                        /// =========================
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: habitProvider.habits.length,
                          itemBuilder: (context, index) {
                            final habit = habitProvider.habits[index];

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: InkWell(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                onTap: () {
                                  habitProvider.toggleHabit(habit);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: theme.cardColor,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: theme.borderColor.withOpacity(0.5),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      // Icon Box Container
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color:
                                              theme.softColor.withOpacity(0.5),
                                          borderRadius:
                                              BorderRadius.circular(14),
                                        ),
                                        child: Icon(
                                          habit.icon,
                                          color: theme.primaryColor,
                                          size: 26,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      // Text Title & Subtitle
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              habit.title,
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                                color: theme.textColor,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              habit.subtitle,
                                              style: GoogleFonts.poppins(
                                                color: theme.iconColor
                                                    .withOpacity(0.6),
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Checkbox Bulat Status
                                      Icon(
                                        habit.completed
                                            ? Icons.check_circle
                                            : Icons.radio_button_unchecked,
                                        color: habit.completed
                                            ? theme.primaryColor
                                            : theme.borderColor,
                                        size: 28,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),

              const SizedBox(height: 20),

              /// =========================
              /// FOCUS SESSION CARD
              /// =========================
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const FocusPage()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: theme.softColor,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Focus Sesi',
                            style: GoogleFonts.poppins(
                              color: theme.textColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            focusProvider.currentMode.title.isNotEmpty
                                ? focusProvider.currentMode.title
                                : 'Pomodoro',
                            style: GoogleFonts.poppins(
                              color: theme.textColor.withOpacity(0.7),
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            focusProvider.formattedTime.isNotEmpty
                                ? focusProvider.formattedTime
                                : '25:00',
                            style: GoogleFonts.poppins(
                              color: theme.textColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 28,
                            ),
                          ),
                        ],
                      ),
                      // Play Button Bulat Putih / Kontras
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.play_arrow_rounded,
                          color: theme.primaryColor,
                          size: 36,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomNavbar extends StatelessWidget {
  final int currentIndex;

  const _BottomNavbar({
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(
      context,
    ).currentTheme;

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        switch (index) {
          /// HOME

          case 0:
            break;

          /// HABIT

          case 1:
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const HabitPage(),
                ));

            break;

          /// TIMER

          case 2:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const FocusPage(),
              ),
            );

            break;

          /// CALENDAR

          case 3:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const CalendarPage(),
              ),
            );

            break;

          /// PROFILE

          case 4:
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (_) => const ProfilePage()));

            break;
        }
      },
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
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_rounded),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.task_alt),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.timer_outlined),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline_rounded),
          label: '',
        ),
      ],
    );
  }
}
