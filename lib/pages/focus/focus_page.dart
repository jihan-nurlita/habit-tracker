import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:habit_tracker/pages/calendar/calendar_page.dart';
import 'package:habit_tracker/pages/habit/habit_page.dart';
import 'package:habit_tracker/pages/home/home_page.dart';
import 'package:habit_tracker/pages/profile/profile_page.dart';
import 'package:habit_tracker/providers/focus_provider.dart';
import 'package:habit_tracker/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class FocusPage extends StatelessWidget {
  const FocusPage({super.key});

  @override
  Widget build(BuildContext context) {
    final focusProvider = Provider.of<FocusProvider>(context);
    final theme = Provider.of<ThemeProvider>(context).currentTheme;

    return Scaffold(
      bottomNavigationBar: const _BottomNavbar(currentIndex: 2),
      backgroundColor: theme.backgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final availableHeight = constraints.maxHeight;
            final timerSize = (availableHeight * 0.30).clamp(150.0, 220.0);

            return Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: 20,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// =========================
                  /// MODE BUTTON
                  /// =========================
                  Row(
                    children: List.generate(
                      focusProvider.modes.length,
                      (index) {
                        final mode = focusProvider.modes[index];
                        final isSelected = focusProvider.selectedMode == index;

                        return Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                              right: index != focusProvider.modes.length - 1
                                  ? 10
                                  : 0,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                focusProvider.changeMode(index);
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? theme.primaryColor
                                      : theme.softColor,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Center(
                                  child: Text(
                                    mode.title,
                                    style: GoogleFonts.poppins(
                                      color: isSelected
                                          ? Colors.white
                                          : theme.iconColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const Spacer(),

                  /// =========================
                  /// TIMER (UKURAN DINAMIS)
                  /// =========================
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: timerSize,
                        height: timerSize,
                        child: CircularProgressIndicator(
                          value: 1,
                          strokeWidth: 8,
                          color: theme.softColor,
                        ),
                      ),
                      SizedBox(
                        width: timerSize,
                        height: timerSize,
                        child: CircularProgressIndicator(
                          value: focusProvider.progress,
                          strokeWidth: 8,
                          strokeCap: StrokeCap.round,
                          color: theme.iconColor,
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Focus",
                            style: GoogleFonts.poppins(
                              color: theme.textColor,
                              fontWeight: FontWeight.w700,
                              fontSize: timerSize * 0.1,
                            ),
                          ),
                          Text(
                            focusProvider.formattedTime,
                            style: GoogleFonts.poppins(
                              color: theme.textColor,
                              fontWeight: FontWeight.bold,
                              fontSize: timerSize * 0.18,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const Spacer(),

                  /// =========================
                  /// TEXT INFO
                  /// =========================
                  Column(
                    children: [
                      Text(
                        "Ayo Fokus!",
                        style: GoogleFonts.poppins(
                          color: theme.textColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Jangan lupa istirahat setelah sesi ini",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: theme.textColor.withOpacity(0.6),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  /// =========================
                  /// BUTTON ACTION
                  /// =========================
                  Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          onPressed: () {
                            if (focusProvider.isRunning) {
                              focusProvider.pauseFocus();
                            } else {
                              focusProvider.startFocus();
                            }
                          },
                          child: Text(
                            focusProvider.isRunning
                                ? "Pause Focus"
                                : "Start Focus",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        height: 46,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: theme.iconColor,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: () {
                            focusProvider.resetFocus();
                          },
                          child: Text(
                            "Reset",
                            style: GoogleFonts.poppins(
                              color: theme.iconColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  /// =========================
                  /// BOTTOM ICONS
                  /// =========================
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildButton(
                          Icons.music_note_rounded, theme, availableHeight),
                      _buildButton(
                          Icons.bar_chart_rounded, theme, availableHeight),
                      _buildButton(Icons.power_settings_new_rounded, theme,
                          availableHeight),
                      _buildButton(
                          Icons.timer_outlined, theme, availableHeight),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildButton(
    IconData icon,
    dynamic theme,
    double availableHeight,
  ) {
    final boxSize = (availableHeight * 0.08).clamp(44.0, 56.0);

    return Container(
      width: boxSize,
      height: boxSize,
      decoration: BoxDecoration(
        color: theme.softColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(
        icon,
        color: theme.iconColor,
        size: boxSize * 0.45,
      ),
    );
  }
}

class _BottomNavbar extends StatelessWidget {
  final int currentIndex;

  const _BottomNavbar({
    required this.currentIndex,
  });

  void _navigateTo(BuildContext context, Widget page) {
    // Menunda navigasi hingga frame selesai di-render agar tidak bug/lag
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => page,
            transitionDuration:
                Duration.zero, // Menghilangkan delay animasi berlebih
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).currentTheme;

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        if (index == currentIndex)
          return; // Mencegah re-navigate ke halaman yang sama

        switch (index) {
          case 0:
            _navigateTo(context, const HomePage());
            break;
          case 1:
            _navigateTo(context, const HabitPage());
            break;
          case 2:
            // Halaman saat ini (FocusPage), tidak melakukan apa-apa
            break;
          case 3:
            _navigateTo(context, const CalendarPage());
            break;
          case 4:
            _navigateTo(context, const ProfilePage());
            break;
        }
      },
      elevation: 0,
      type: BottomNavigationBarType.fixed,
      backgroundColor: theme.cardColor,
      selectedItemColor: theme.primaryColor,
      unselectedItemColor: Colors.grey,
      selectedIconTheme: const IconThemeData(size: 26),
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
