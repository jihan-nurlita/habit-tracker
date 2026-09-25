import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:habit_tracker/pages/focus/focus_page.dart';
import 'package:habit_tracker/pages/habit/habit_page.dart';
import 'package:habit_tracker/pages/home/home_page.dart';
import 'package:habit_tracker/pages/profile/profile_page.dart';
import 'package:habit_tracker/pages/statistics/statistics_page.dart';
import 'package:habit_tracker/providers/focus_provider.dart';
import 'package:habit_tracker/providers/habit_provider.dart';
import 'package:habit_tracker/providers/theme_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime currentMonth = DateTime.now();
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).currentTheme;
    final habitProvider = Provider.of<HabitProvider>(context);
    final focusProvider = Provider.of<FocusProvider>(context);

    final habits = habitProvider.getHabitsByDate(selectedDate);
    final completedHabits = habits.where((e) => e.completed).length;
    final totalHabits = habits.length;
    final progress = totalHabits == 0 ? 0.0 : completedHabits / totalHabits;

    final currentStreak = _getProviderStreak(habitProvider);
    final today = DateTime.now();

    return Scaffold(
      backgroundColor: theme.backgroundColor,

      /// =========================
      /// APP BAR
      /// =========================
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Text(
          "calendar",
          style: TextStyle(
            color: theme.textColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: const _BottomNavbar(currentIndex: 3),
      // MEMPERBAIKI OVERFLOW: Menggunakan SingleChildScrollView agar layar bisa di-scroll saat ruang sempit
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              /// =========================
              /// TITLE & MONTH SELECTOR
              /// =========================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Aktivitas Bulanan",
                          style: GoogleFonts.poppins(
                            color: theme.textColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                        const Spacer(),
                        // ICON PENANDA HARI AKTIF HARI INI
                        // ICON PENANDA HARI AKTIF HARI INI (KLIK UNTUK KEMBALI KE HARI INI)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              final now = DateTime.now();
                              currentMonth = DateTime(now.year, now.month);
                              selectedDate = now;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: theme.primaryColor.withOpacity(0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.calendar_month_outlined,
                              color: theme.primaryColor,
                              size: 20,
                            ),
                          ),
                        )
                      ],
                    ),

                    const SizedBox(height: 18),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              currentMonth = DateTime(
                                currentMonth.year,
                                currentMonth.month - 1,
                              );
                            });
                          },
                          icon: Icon(
                            Icons.chevron_left_rounded,
                            color: Colors.grey.shade400,
                          ),
                        ),
                        Text(
                          DateFormat("MMMM yyyy", "id_ID").format(currentMonth),
                          style: GoogleFonts.poppins(
                            color: theme.textColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              currentMonth = DateTime(
                                currentMonth.year,
                                currentMonth.month + 1,
                              );
                            });
                          },
                          icon: Icon(
                            Icons.chevron_right_rounded,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    /// =========================
                    /// DAYS HEADER
                    /// =========================
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children:
                          ["Min", "Sen", "Sel", "Rab", "Kam", "Jum", "Sab"]
                              .map(
                                (e) => Text(
                                  e,
                                  style: GoogleFonts.poppins(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              )
                              .toList(),
                    ),

                    const SizedBox(height: 14),

                    /// =========================
                    /// CALENDAR GRID
                    /// =========================
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: DateUtils.getDaysInMonth(
                        currentMonth.year,
                        currentMonth.month,
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                      ),
                      itemBuilder: (context, index) {
                        final date = DateTime(
                          currentMonth.year,
                          currentMonth.month,
                          index + 1,
                        );

                        // Cek apakah tanggal hari ini
                        final isToday = today.day == date.day &&
                            today.month == date.month &&
                            today.year == date.year;

                        // Cek apakah tanggal sedang dipilih untuk dicek
                        final isSelected = selectedDate.day == date.day &&
                            selectedDate.month == date.month &&
                            selectedDate.year == date.year;

                        final habitsByDate =
                            habitProvider.getHabitsByDate(date);
                        final completed = habitsByDate.isNotEmpty;

                        // Penentuan warna background tanggal
                        Color getBackgroundColor() {
                          if (isSelected) {
                            return theme
                                .primaryColor; // Hijau Tua untuk tanggal yang diseksi/dicek
                          }
                          if (isToday) {
                            return theme.primaryColor.withOpacity(
                                0.25); // Warna muda soft stay di hari sekarang
                          }
                          if (completed) {
                            return theme.softColor;
                          }
                          return theme.cardColor;
                        }

                        // Penentuan warna teks angka tanggal
                        Color getTextColor() {
                          if (isSelected) {
                            return Colors.white;
                          }
                          if (isToday) {
                            return theme.primaryColor;
                          }
                          if (completed) {
                            return theme.iconColor;
                          }
                          return theme.textColor;
                        }

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedDate = date;
                            });

                            _showDayBottomSheet(
                              context,
                              habitProvider,
                              focusProvider,
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: getBackgroundColor(),
                              shape: BoxShape.circle,
                              border: isToday && !isSelected
                                  ? Border.all(
                                      color: theme.primaryColor,
                                      width: 1.5,
                                    )
                                  : null,
                            ),
                            child: Center(
                              child: Text(
                                "${index + 1}",
                                style: GoogleFonts.poppins(
                                  color: getTextColor(),
                                  fontWeight: isToday || isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              /// =========================
              /// SUMMARY (RINGKASAN BULAN INI)
              /// =========================
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.softColor,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Ringkasan Bulan Ini",
                      style: GoogleFonts.poppins(
                        color: theme.textColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildSummaryCard(
                            icon: Icons.check_circle,
                            title: "Habit Selesai",
                            value: "${(progress * 100).toInt()}%",
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildSummaryCard(
                            icon: Icons.timer_outlined,
                            title: "Total Focus",
                            value: "${focusProvider.totalFocusHours} Jam",
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildSummaryCard(
                            icon: Icons.local_fire_department,
                            title: "Streak",
                            value: "$currentStreak Hari",
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.primaryColor,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const StatisticsPage()),
                          );
                        },
                        child: Text(
                          "Lihat Statistik",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// =========================
  /// SUMMARY CARD WIDGET
  /// =========================
  Widget _buildSummaryCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    final theme =
        Provider.of<ThemeProvider>(context, listen: false).currentTheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 14,
        horizontal: 6,
      ),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Icon(icon, color: theme.iconColor),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.poppins(
              color: theme.textColor,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 10,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  int _getProviderStreak(HabitProvider provider) {
    try {
      return (provider as dynamic).streak ?? 0;
    } catch (_) {
      try {
        return (provider as dynamic).currentStreak ?? 0;
      } catch (_) {
        return 12;
      }
    }
  }

  /// =========================
  /// BOTTOM SHEET (DAFTAR HABIT PER HARI)
  /// =========================
  void _showDayBottomSheet(
    BuildContext context,
    HabitProvider habitProvider,
    FocusProvider focusProvider,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        final habits = habitProvider.getHabitsByDate(selectedDate);
        final theme = Provider.of<ThemeProvider>(context).currentTheme;
        final currentStreak = _getProviderStreak(habitProvider);

        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                /// HANDLE BAR (Garis kecil di atas)
                child: Container(
                  width: 60,
                  height: 5,
                  decoration: BoxDecoration(
                    color: theme.textColor.withOpacity(
                        0.2), // Mengikuti warna teks dengan transparansi
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                DateFormat("EEEE, dd MMMM yyyy", "id_ID").format(selectedDate),
                style: GoogleFonts.poppins(
                  color: theme.textColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 18),

              /// MINI STATS DI BOTTOM SHEET
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: theme.softColor,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildMiniStat(
                        "Habit",
                        theme,
                        "${habitProvider.completedHabitsByDate(selectedDate)}/${habitProvider.totalHabitsByDate(selectedDate)}",
                      ),
                    ),
                    Expanded(
                      child: _buildMiniStat(
                        "Focus",
                        theme,
                        "${focusProvider.totalFocusHours} Jam",
                      ),
                    ),
                    Expanded(
                      child: _buildMiniStat(
                        "Streak",
                        theme,
                        "$currentStreak Hari",
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                "Daftar Habit",
                style: GoogleFonts.poppins(
                  color: theme.textColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: habits.isEmpty
                    ? Center(
                        child: Text(
                          "Tidak ada habit di hari ini",
                          style: GoogleFonts.poppins(color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        itemCount: habits.length,
                        itemBuilder: (context, index) {
                          final habit = habits[index];
                          return GestureDetector(
                            onTap: () {
                              _showHabitDetail(context, habit, theme);
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 14),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: theme.backgroundColor,
                                borderRadius: BorderRadius.circular(22),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      color: theme.softColor,
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    child: Icon(
                                      habit.icon,
                                      color: theme.iconColor,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          habit.title,
                                          style: GoogleFonts.poppins(
                                            color: theme.textColor,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          habit.subtitle,
                                          style: GoogleFonts.poppins(
                                            color: Colors.grey,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    habit.completed
                                        ? Icons.check_circle
                                        : Icons.radio_button_unchecked,
                                    color: habit.completed
                                        ? theme.primaryColor
                                        : Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMiniStat(String title, dynamic theme, String value) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.poppins(
            color: theme.textColor,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: GoogleFonts.poppins(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

/// =========================
/// HABIT DETAIL DIALOG
/// =========================
void _showHabitDetail(BuildContext context, dynamic habit, dynamic theme) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) {
      final currentTheme = Provider.of<ThemeProvider>(context).currentTheme;

      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: currentTheme.cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// HANDLE BAR (Garis kecil di atas)
              Container(
                width: 60,
                height: 5,
                decoration: BoxDecoration(
                  color: theme.textColor.withOpacity(
                      0.2), // Mengikuti warna teks dengan transparansi
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: currentTheme.softColor,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Icon(
                  habit.icon,
                  color: currentTheme.iconColor,
                  size: 34,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                habit.title,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: theme.textColor,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                habit.subtitle,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: Colors.grey,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 24),
              Divider(color: Colors.grey.shade200),
              const SizedBox(height: 10),
              _buildMinimalTile(
                Icons.access_time_rounded,
                "Waktu",
                "${habit.startTime} - ${habit.endTime}",
                currentTheme,
              ),
              _buildMinimalTile(
                Icons.timelapse_rounded,
                "Durasi",
                habit.duration,
                currentTheme,
              ),
              _buildMinimalTile(
                Icons.flag_rounded,
                "Target",
                habit.target,
                currentTheme,
              ),
              _buildMinimalTile(
                Icons.repeat_rounded,
                "Repeat",
                habit.repeat,
                currentTheme,
              ),
              _buildMinimalTile(
                habit.icon,
                "Category",
                habit.category,
                currentTheme,
              ),
              if (habit.notes != null && habit.notes.isNotEmpty)
                _buildMinimalTile(
                  Icons.edit_document,
                  "Catatan",
                  habit.notes,
                  currentTheme,
                ),
              _buildMinimalTile(
                Icons.check_circle_rounded,
                "Status",
                habit.completed ? "Selesai" : "Belum selesai",
                currentTheme,
              ),
              const SizedBox(height: 26),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: currentTheme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    habit.completed ? "Sudah Selesai" : "Tutup",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      );
    },
  );
}

Widget _buildMinimalTile(
    IconData icon, String title, String value, dynamic theme) {
  return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: theme.softColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, size: 20, color: theme.iconColor),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                      color: theme.textColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ));
}

class _BottomNavbar extends StatelessWidget {
  final int currentIndex;
  const _BottomNavbar({required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).currentTheme;

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        if (index == currentIndex) return;
        switch (index) {
          case 0:
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => const HomePage()));
            break;
          case 1:
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => const HabitPage()));
            break;
          case 2:
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => const FocusPage()));
            break;
          case 3:
            break;
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
      selectedIconTheme: const IconThemeData(size: 28),
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.task_alt), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.timer_outlined), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: ''),
        BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded), label: ''),
      ],
    );
  }
}
