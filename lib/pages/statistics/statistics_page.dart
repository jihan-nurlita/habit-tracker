import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:habit_tracker/providers/focus_provider.dart';
import 'package:habit_tracker/providers/habit_provider.dart';
import 'package:habit_tracker/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  DateTime selectedMonth = DateTime.now();

  int _daysInMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0).day;
  }

  double _getCompletionRatioForDate(HabitProvider provider, DateTime date) {
    final habitsForMonth = provider.getHabitsByMonth(date);

    final habitsForDay = habitsForMonth.where((h) {
      return h.date.year == date.year &&
          h.date.month == date.month &&
          h.date.day == date.day;
    }).toList();

    if (habitsForDay.isEmpty) return 0.0;

    final completedCount = habitsForDay.where((e) => e.completed).length;
    return completedCount / habitsForDay.length;
  }

  @override
  Widget build(BuildContext context) {
    final habitProvider = Provider.of<HabitProvider>(context);
    final focusProvider = Provider.of<FocusProvider>(context);
    final theme = Provider.of<ThemeProvider>(context).currentTheme;

    // Kalkulasi Data Bulanan
    final habitsThisMonth = habitProvider.getHabitsByMonth(selectedMonth);
    final completedHabits = habitsThisMonth.where((e) => e.completed).length;
    final totalHabits = habitsThisMonth.length;
    final monthlyPercent =
        totalHabits == 0 ? 0 : ((completedHabits / totalHabits) * 100).toInt();

    // ==========================================
    // 1. HITUNG HABIT PALING KONSISTEN
    // ==========================================
    String mostConsistentHabitName = "-";
    int maxCompletedCount = 0;

    if (habitsThisMonth.isNotEmpty) {
      final Map<String, int> completionCounts = {};

      for (var h in habitsThisMonth) {
        if (h.completed) {
          completionCounts[h.title] = (completionCounts[h.title] ?? 0) + 1;
        }
      }

      if (completionCounts.isNotEmpty) {
        var topEntry = completionCounts.entries.reduce(
          (a, b) => a.value > b.value ? a : b,
        );
        mostConsistentHabitName = topEntry.key;
        maxCompletedCount = topEntry.value;
      } else {
        mostConsistentHabitName = habitsThisMonth.first.title;
      }
    }

    // ==========================================
    // 2. HITUNG STREAK TERPANJANG
    // ==========================================
    String longestStreakHabit = "-";
    int maxStreakDays = 0;

    final uniqueHabitTitles = habitsThisMonth.map((e) => e.title).toSet();

    for (var title in uniqueHabitTitles) {
      final history = habitsThisMonth
          .where((h) => h.title == title && h.completed)
          .toList()
        ..sort((a, b) => a.date.compareTo(b.date));

      int currentStreak = 0;
      int tempStreak = 0;
      DateTime? previousDate;

      for (var item in history) {
        if (previousDate == null) {
          tempStreak = 1;
        } else {
          final difference = item.date.difference(previousDate).inDays;
          if (difference == 1) {
            tempStreak++;
          } else if (difference > 1) {
            tempStreak = 1;
          }
        }
        previousDate = item.date;
        if (tempStreak > currentStreak) {
          currentStreak = tempStreak;
        }
      }

      if (currentStreak > maxStreakDays) {
        maxStreakDays = currentStreak;
        longestStreakHabit = title;
      }
    }

    // ==========================================
    // 3. RENTANG MINGGUAN (SENIN SAMPAI MINGGU)
    // ==========================================
    final now = DateTime.now();
    // Cari tanggal hari Senin minggu ini (weekday: 1 = Senin, 7 = Minggu)
    final mondayThisWeek = now.subtract(Duration(days: now.weekday - 1));

    // Generasi 7 hari berturut-turut dari Senin sampai Minggu
    final weekDays = List.generate(7, (index) {
      return mondayThisWeek.add(Duration(days: index));
    });

    final weekStartDate = DateFormat("dd").format(weekDays.first);
    final weekEndDate = DateFormat("dd").format(weekDays.last);

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: theme.primaryColor),
        ),
        title: Text(
          "Statistik",
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: theme.textColor),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// TOP STATS GRID
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.15,
                children: [
                  _buildStatCard(
                    title: "Habit Selesai",
                    value: "$monthlyPercent%",
                    subtitle: "Bulan Ini",
                    theme: theme,
                  ),
                  _buildStatCard(
                    title: "Total Fokus",
                    value: focusProvider.totalFocusHours,
                    subtitle: "Jam Fokus",
                    theme: theme,
                  ),
                  _buildHabitStatCard(
                    title: "Paling Konsisten",
                    habit: mostConsistentHabitName,
                    value: maxCompletedCount > 0
                        ? "$maxCompletedCount Kali"
                        : "0 Kali",
                    theme: theme,
                  ),
                  _buildHabitStatCard(
                    title: "Streak Terpanjang",
                    habit: longestStreakHabit,
                    value: maxStreakDays > 0 ? "$maxStreakDays Hari" : "0 Hari",
                    theme: theme,
                  ),
                ],
              ),
              const SizedBox(height: 28),

              /// WEEKLY PROGRESS (SENIN - MINGGU)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Mingguan",
                    style: GoogleFonts.poppins(
                      color: theme.textColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    "$weekStartDate - $weekEndDate",
                    style: GoogleFonts.poppins(
                      color: theme.primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: weekDays.map((date) {
                    final dayName = DateFormat("EEE", "id_ID").format(date);
                    final ratio =
                        _getCompletionRatioForDate(habitProvider, date);
                    return _buildUnifiedBar(
                      label: dayName,
                      ratio: ratio,
                      theme: theme,
                      barWidth: 22,
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 28),

              /// MONTHLY PROGRESS
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Bulanan",
                    style: GoogleFonts.poppins(
                      color: theme.textColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => setState(() => selectedMonth = DateTime(
                            selectedMonth.year, selectedMonth.month - 1)),
                        child: const Icon(Icons.chevron_left_rounded, size: 24),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat("MMMM yyyy", "id_ID").format(selectedMonth),
                        style: GoogleFonts.poppins(
                          color: theme.primaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () => setState(() => selectedMonth = DateTime(
                            selectedMonth.year, selectedMonth.month + 1)),
                        child:
                            const Icon(Icons.chevron_right_rounded, size: 24),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: SizedBox(
                  height: 165,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _daysInMonth(selectedMonth),
                    itemBuilder: (context, index) {
                      final dayDate = DateTime(
                          selectedMonth.year, selectedMonth.month, index + 1);
                      final ratio =
                          _getCompletionRatioForDate(habitProvider, dayDate);

                      return Padding(
                        padding: const EdgeInsets.only(right: 14),
                        child: _buildUnifiedBar(
                          label: "${index + 1}",
                          ratio: ratio,
                          theme: theme,
                          barWidth: 22,
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  /// HELPER STAT CARDS
  Widget _buildStatCard({
    required String title,
    required String value,
    required String subtitle,
    required dynamic theme,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Colors.black.withOpacity(0.02),
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
                color: Colors.grey.shade500,
                fontSize: 11,
                fontWeight: FontWeight.w500),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.poppins(
                color: theme.textColor,
                fontSize: 24,
                fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: GoogleFonts.poppins(
                color: theme.primaryColor,
                fontSize: 10,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildHabitStatCard({
    required String title,
    required String habit,
    required String value,
    required dynamic theme,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Colors.black.withOpacity(0.02),
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
                color: Colors.grey.shade500,
                fontSize: 11,
                fontWeight: FontWeight.w500),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: theme.primaryColor.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.local_fire_department_rounded,
                    size: 18, color: theme.primaryColor),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      habit,
                      style: GoogleFonts.poppins(
                          color: theme.textColor.withOpacity(0.6),
                          fontWeight: FontWeight.w600,
                          fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      value,
                      style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: theme.textColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// HELPER UNIFIED PROGRESS BAR
  Widget _buildUnifiedBar({
    required String label,
    required double ratio,
    required dynamic theme,
    double barWidth = 22,
  }) {
    const double barMaxHeight = 100.0;
    final int percentage = (ratio.clamp(0.0, 1.0) * 100).toInt();

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          height: 16,
          child: FittedBox(
            child: Text(
              "$percentage%",
              style: GoogleFonts.poppins(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: barWidth,
          height: barMaxHeight,
          decoration: BoxDecoration(
            color: theme.primaryColor.withOpacity(0.12),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              FractionallySizedBox(
                heightFactor: ratio.clamp(0.0, 1.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.primaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.poppins(
            color: theme.textColor,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
