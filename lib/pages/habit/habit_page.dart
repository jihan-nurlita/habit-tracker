import 'package:flutter/material.dart';
import 'package:habit_tracker/pages/calendar/calendar_page.dart';
import 'package:habit_tracker/pages/focus/focus_page.dart';
import 'package:habit_tracker/pages/habit/add_habit_page.dart';
import 'package:habit_tracker/pages/habit/widgets/habit_tile.dart';
import 'package:habit_tracker/pages/home/home_page.dart';
import 'package:habit_tracker/pages/profile/profile_page.dart';
import 'package:habit_tracker/providers/habit_provider.dart';
import 'package:habit_tracker/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class HabitPage extends StatefulWidget {
  const HabitPage({super.key});

  @override
  State<HabitPage> createState() => _HabitPageState();
}

class _HabitPageState extends State<HabitPage> {
  late ScrollController _scrollController;

  DateTime selectedDate = DateTime.now();

  String selectedCategory = "Semua";

  final categories = [
    "Semua",
    "Pribadi",
    "Kesehatan",
    "Olahraga",
    "Belajar",
    "Kerja",
    "Produktivitas",
    "Keuangan",
    "Rumah",
    "Sosial",
    "Hobi",
    "Perjalanan",
    "Ibadah",
  ];

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentDay = DateTime.now().day;

      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          (currentDay - 1) * 72,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// =========================
  /// OPEN ADD HABIT
  /// =========================

  void _addHabit() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AddHabitPage(),
      ),
    );
  }

  /// =========================
  /// OPEN EDIT HABIT
  /// =========================

  Future<void> _editHabit(dynamic habit) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddHabitPage(
          habit: habit,
        ),
      ),
    );
  }

  /// =========================
  /// DELETE CONFIRMATION
  /// =========================

  Future<bool> _confirmDelete(
    dynamic habit,
  ) async {
    final theme = Provider.of<ThemeProvider>(
      context,
      listen: false,
    ).currentTheme;

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: theme.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Text(
            "Hapus Habit?",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Apakah kamu yakin ingin menghapus "${habit.title}"?',
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: Text(
                "Batal",
                style: TextStyle(
                  color: theme.iconColor,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text(
                "Hapus",
              ),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(
      context,
    ).currentTheme;

    final habitProvider = Provider.of<HabitProvider>(
      context,
    );

    List habits = habitProvider.getHabitsByDate(
      selectedDate,
    );

    if (selectedCategory != "Semua") {
      habits = habits.where((e) {
        return e.category.toString().toLowerCase() ==
            selectedCategory.toLowerCase();
      }).toList();
    }

    return Scaffold(
      backgroundColor: theme.backgroundColor,

      /// =========================
      /// FLOATING BUTTON
      /// =========================

      floatingActionButton: FloatingActionButton(
        backgroundColor: theme.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        onPressed: _addHabit,
        child: const Icon(
          Icons.add,
          size: 32,
          color: Colors.white,
        ),
      ),

      /// =========================
      /// APP BAR
      /// =========================

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            "Habit",
            style: TextStyle(
              color: theme.textColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),

      /// =========================
      /// BOTTOM NAVBAR
      /// =========================

      bottomNavigationBar: const _BottomNavbar(
        currentIndex: 1,
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// =========================
              /// DATE SELECTOR
              /// =========================

              SizedBox(
                height: 90,
                child: ListView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: DateUtils.getDaysInMonth(
                    selectedDate.year,
                    selectedDate.month,
                  ),
                  itemBuilder: (context, index) {
                    final date = DateTime(
                      selectedDate.year,
                      selectedDate.month,
                      index + 1,
                    );

                    final isSelected = selectedDate.day == date.day &&
                        selectedDate.month == date.month &&
                        selectedDate.year == date.year;

                    final now = DateTime.now();

                    final isToday = now.day == date.day &&
                        now.month == date.month &&
                        now.year == date.year;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDate = date;
                        });
                      },
                      child: _buildDateItem(
                        day: [
                          "Min",
                          "Sen",
                          "Sel",
                          "Rab",
                          "Kam",
                          "Jum",
                          "Sab",
                        ][date.weekday % 7],
                        date: "${date.day}",
                        active: isSelected,
                        isToday: isToday,
                        theme: theme,
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 18),

              /// =========================
              /// CATEGORY CHIPS
              /// =========================

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: categories.map((category) {
                    final selected = selectedCategory == category;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCategory = category;
                        });
                      },
                      child: _buildCategoryChip(
                        title: category,
                        selected: selected,
                        theme: theme,
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 22),

              /// =========================
              /// HABIT LIST
              /// =========================

              Expanded(
                child: habits.isEmpty
                    ? _buildEmptyState(theme)
                    : ListView.separated(
                        padding: const EdgeInsets.only(
                          bottom: 90,
                        ),
                        itemCount: habits.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final habit = habits[index];

                          return Dismissible(
                            key: ObjectKey(habit),

                            /// Hanya izinkan horizontal
                            direction: DismissDirection.horizontal,

                            /// =========================
                            /// SWIPE KANAN
                            /// =========================
                            background: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
                              decoration: BoxDecoration(
                                color: theme.primaryColor,
                                borderRadius: BorderRadius.circular(24),
                              ),
                              alignment: Alignment.centerLeft,
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.edit_rounded,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    "Edit",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            /// =========================
                            /// SWIPE KIRI
                            /// =========================
                            secondaryBackground: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(24),
                              ),
                              alignment: Alignment.centerRight,
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "Hapus",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Icon(
                                    Icons.delete_rounded,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ],
                              ),
                            ),

                            /// =========================
                            /// CONFIRM SWIPE
                            /// =========================

                            confirmDismiss: (direction) async {
                              /// SWIPE KANAN = EDIT
                              if (direction == DismissDirection.startToEnd) {
                                await _editHabit(habit);

                                /// Jangan hapus card
                                return false;
                              }

                              /// SWIPE KIRI = DELETE
                              if (direction == DismissDirection.endToStart) {
                                return await _confirmDelete(
                                  habit,
                                );
                              }

                              return false;
                            },

                            /// =========================
                            /// AFTER DELETE
                            /// =========================

                            onDismissed: (direction) {
                              if (direction == DismissDirection.endToStart) {
                                habitProvider.deleteHabit(
                                  habit,
                                );

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      '"${habit.title}" dihapus',
                                    ),
                                    behavior: SnackBarBehavior.floating,
                                    action: SnackBarAction(
                                      label: "OK",
                                      onPressed: () {},
                                    ),
                                  ),
                                );
                              }
                            },

                            child: HabitTile(
                              icon: habit.icon,
                              title: habit.title,
                              subtitle: habit.subtitle,
                              schedule: "${habit.repeat} • ${habit.startTime}",
                              completed: habit.completed,
                              onTap: () {
                                habitProvider.toggleHabit(
                                  habit,
                                );
                              },
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// =========================
  /// EMPTY STATE
  /// =========================

  Widget _buildEmptyState(dynamic theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 50,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle_outline_rounded,
              size: 64,
              color: theme.primaryColor.withOpacity(0.45),
            ),
            const SizedBox(height: 16),
            Text(
              selectedCategory == "Semua"
                  ? "Belum ada habit"
                  : "Belum ada habit $selectedCategory",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: theme.textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Tekan tombol + untuk menambahkan habit.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: theme.textColor.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// =========================
  /// DATE ITEM
  /// =========================

  Widget _buildDateItem({
    required String day,
    required String date,
    required bool active,
    required bool isToday,
    required dynamic theme,
  }) {
    return Container(
      width: 60,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: active
            ? theme.primaryColor
            : isToday
                ? theme.softColor
                : theme.cardColor,
        borderRadius: BorderRadius.circular(60),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            day,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: active
                  ? Colors.white
                  : isToday
                      ? theme.iconColor
                      : theme.textColor,
            ),
          ),
          const SizedBox(height: 8),
          CircleAvatar(
            radius: 18,
            backgroundColor: active
                ? theme.softColor
                : isToday
                    ? theme
                        .cardColor // <--- Pakai cardColor! (Putih di Light, Hitam di Dark)
                    : theme.softColor,
            child: Text(
              date,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                // Jika isToday & tidak aktif: di Light Mode pakai primaryColor, di Dark Mode pakai textColor (putih)
                color: active
                    ? theme.iconColor
                    : isToday
                        ? (theme.cardColor == Colors.white
                            ? theme.primaryColor
                            : theme.textColor)
                        : theme.iconColor,
              ),
            ),
          )
        ],
      ),
    );
  }

  /// =========================
  /// CATEGORY CHIP
  /// =========================

  Widget _buildCategoryChip({
    required String title,
    bool selected = false,
    required dynamic theme,
  }) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: selected ? theme.primaryColor : theme.softColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: selected ? Colors.white : theme.iconColor,
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
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const HomePage(),
              ),
            );
            break;

          /// HABIT
          case 1:
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
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const ProfilePage(),
              ),
            );
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
