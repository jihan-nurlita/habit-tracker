import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:habit_tracker/providers/focus_provider.dart';
import 'package:habit_tracker/providers/habit_provider.dart';
import 'package:habit_tracker/providers/theme_provider.dart';
import 'package:provider/provider.dart';

enum StatsViewType {
  weekly,
  monthly,
  yearly,
}

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  StatsViewType currentView = StatsViewType.weekly;
  DateTime selectedDate = DateTime.now();

  final List<String> _shortMonthNames = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'Mei',
    'Jun',
    'Jul',
    'Agu',
    'Sep',
    'Okt',
    'Nov',
    'Des',
  ];

  final List<String> _fullMonthNames = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  @override
  Widget build(BuildContext context) {
    final habitProvider = Provider.of<HabitProvider>(context);
    final focusProvider = Provider.of<FocusProvider>(context);
    final theme = Provider.of<ThemeProvider>(context).currentTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Kalkulasi Data Bulanan untuk Kartu Ringkasan
    final habitsThisMonth = habitProvider.getHabitsByMonth(selectedDate);
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
    // 3. DATA GRAFIK (FL_CHART)
    // ==========================================
    List<double> chartData = [];
    List<String> labels = [];
    String periodLabel = "";

    if (currentView == StatsViewType.weekly) {
      final monday =
          selectedDate.subtract(Duration(days: selectedDate.weekday - 1));
      final sunday = monday.add(const Duration(days: 6));

      labels = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
      chartData = List.generate(7, (i) {
        final day = monday.add(Duration(days: i));
        final habitsForDay = habitsThisMonth
            .where((h) =>
                h.date.year == day.year &&
                h.date.month == day.month &&
                h.date.day == day.day)
            .toList();
        if (habitsForDay.isEmpty) return 0.0;
        final comp = habitsForDay.where((e) => e.completed).length;
        return (comp / habitsForDay.length) * 100;
      });

      periodLabel =
          "${monday.day} ${_shortMonthNames[monday.month - 1]} - ${sunday.day} ${_shortMonthNames[sunday.month - 1]} ${sunday.year}";
    } else if (currentView == StatsViewType.monthly) {
      final daysInMonth =
          DateTime(selectedDate.year, selectedDate.month + 1, 0).day;
      labels = List.generate(daysInMonth, (i) => "${i + 1}");

      chartData = List.generate(daysInMonth, (i) {
        final day = DateTime(selectedDate.year, selectedDate.month, i + 1);
        final habitsForDay = habitsThisMonth
            .where((h) =>
                h.date.year == day.year &&
                h.date.month == day.month &&
                h.date.day == day.day)
            .toList();
        if (habitsForDay.isEmpty) return 0.0;
        final comp = habitsForDay.where((e) => e.completed).length;
        return (comp / habitsForDay.length) * 100;
      });

      periodLabel =
          "${_fullMonthNames[selectedDate.month - 1]} ${selectedDate.year}";
    } else {
      labels = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'Mei',
        'Jun',
        'Jul',
        'Agu',
        'Sep',
        'Okt',
        'Nov',
        'Des'
      ];
      chartData = List.generate(12, (i) {
        double monthTotal = 0;
        final daysInMonth = DateTime(selectedDate.year, i + 2, 0).day;
        for (int d = 1; d <= daysInMonth; d++) {
          final day = DateTime(selectedDate.year, i + 1, d);
          final habitsForDay = habitsThisMonth
              .where((h) =>
                  h.date.year == day.year &&
                  h.date.month == day.month &&
                  h.date.day == day.day)
              .toList();
          if (habitsForDay.isNotEmpty) {
            final comp = habitsForDay.where((e) => e.completed).length;
            monthTotal += (comp / habitsForDay.length) * 100;
          }
        }
        return daysInMonth > 0 ? (monthTotal / daysInMonth) : 0.0;
      });

      periodLabel = "${selectedDate.year}";
    }

    double chartWidth;
    if (currentView == StatsViewType.weekly) {
      // Ubah angka 60.0 di bawah ini untuk mengatur jarak antar hari pada mode Minggu
      // Makin besar angkanya, makin lebar jaraknya dan makin enak di-scroll
      chartWidth = 7 * 55.0;
    } else if (currentView == StatsViewType.monthly) {
      chartWidth = chartData.length * 36.0;
    } else {
      chartWidth = chartData.length * 52.0;
    }

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
              /// 1. TOGGLE (Minggu / Bulan / Tahun) DI ATAS
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: theme.cardColor,
                  border: Border.all(
                    color: theme.textColor.withOpacity(0.1),
                  ),
                ),
                child: Row(
                  children: [
                    _buildToggle(
                        title: "Minggu",
                        type: StatsViewType.weekly,
                        theme: theme),
                    _buildToggle(
                        title: "Bulan",
                        type: StatsViewType.monthly,
                        theme: theme),
                    _buildToggle(
                        title: "Tahun",
                        type: StatsViewType.yearly,
                        theme: theme),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              /// 2. PERIOD NAVIGATOR (PANAH KIRI / KANAN & TANGGAL)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: previousPeriod,
                    icon: Icon(Icons.chevron_left,
                        color: theme.primaryColor, size: 28),
                  ),
                  Text(
                    periodLabel,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: theme.textColor,
                    ),
                  ),
                  IconButton(
                    onPressed: nextPeriod,
                    icon: Icon(Icons.chevron_right,
                        color: theme.primaryColor, size: 28),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              /// 3. KARTU GRAFIK AKTIVITAS UTAMA
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Habit Activity",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: theme.textColor,
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 240,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: SizedBox(
                          width: chartWidth <
                                  MediaQuery.of(context).size.width - 80
                              ? MediaQuery.of(context).size.width - 80
                              : chartWidth,
                          child: BarChart(
                            BarChartData(
                              maxY: 100,
                              alignment: BarChartAlignment.spaceAround,
                              borderData: FlBorderData(show: false),
                              gridData: FlGridData(
                                show: true,
                                drawVerticalLine: false,
                                horizontalInterval: 20,
                                getDrawingHorizontalLine: (value) {
                                  return FlLine(
                                    color: isDark
                                        ? Colors.white12
                                        : Colors.grey.shade200,
                                    strokeWidth: 1,
                                  );
                                },
                              ),
                              titlesData: FlTitlesData(
                                topTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false)),
                                rightTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false)),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 35,
                                    interval: 20,
                                    getTitlesWidget: (value, meta) {
                                      if (value == 0) return const SizedBox();
                                      return Text(
                                        "${value.toInt()}%",
                                        style: GoogleFonts.poppins(
                                          color:
                                              theme.textColor.withOpacity(0.6),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 10,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 30,
                                    getTitlesWidget: (value, meta) {
                                      final index = value.toInt();
                                      if (index < 0 || index >= labels.length) {
                                        return const SizedBox();
                                      }
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Text(
                                          labels[index],
                                          style: GoogleFonts.poppins(
                                            color: theme.textColor
                                                .withOpacity(0.6),
                                            fontWeight: FontWeight.w700,
                                            fontSize: 11,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              barGroups: List.generate(
                                chartData.length,
                                (index) {
                                  final value = chartData[index];
                                  double rodWidth =
                                      currentView == StatsViewType.weekly
                                          ? 22
                                          : 22;

                                  return BarChartGroupData(
                                    x: index,
                                    barRods: [
                                      BarChartRodData(
                                        toY: value,
                                        width: rodWidth,
                                        borderRadius: BorderRadius.circular(6),
                                        gradient: LinearGradient(
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                          colors: [
                                            theme.primaryColor,
                                            theme.primaryColor.withOpacity(0.4),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              /// 4 KOTAK STATISTIK DI BAGIAN BAWAH
              Text(
                "Ringkasan",
                style: GoogleFonts.poppins(
                  color: theme.textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
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
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  void previousPeriod() {
    setState(() {
      if (currentView == StatsViewType.weekly) {
        selectedDate = selectedDate.subtract(const Duration(days: 7));
      } else if (currentView == StatsViewType.monthly) {
        selectedDate = DateTime(selectedDate.year, selectedDate.month - 1);
      } else {
        selectedDate = DateTime(selectedDate.year - 1);
      }
    });
  }

  void nextPeriod() {
    setState(() {
      if (currentView == StatsViewType.weekly) {
        selectedDate = selectedDate.add(const Duration(days: 7));
      } else if (currentView == StatsViewType.monthly) {
        selectedDate = DateTime(selectedDate.year, selectedDate.month + 1);
      } else {
        selectedDate = DateTime(selectedDate.year + 1);
      }
    });
  }

  Widget _buildToggle({
    required String title,
    required StatsViewType type,
    required dynamic theme,
  }) {
    final isSelected = currentView == type;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            currentView = type;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: isSelected ? theme.primaryColor : Colors.transparent,
          ),
          child: Center(
            child: Text(
              title,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: isSelected
                    ? Colors.white
                    : theme.textColor.withOpacity(0.6),
              ),
            ),
          ),
        ),
      ),
    );
  }

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
}
