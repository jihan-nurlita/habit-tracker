import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/habit_model.dart';

class HabitProvider extends ChangeNotifier {
  List<HabitModel> _habits = [];

  List<HabitModel> get habits => _habits;

  // Key untuk SharedPreferences
  static const String _storageKey = 'saved_habits_key';

  /// Constructor: Langsung muat data dari SharedPreferences saat Provider dibuat
  HabitProvider() {
    _loadHabitsFromStorage();
  }

  /// =======================
  /// LOCAL STORAGE (SHARED PREFERENCES)
  /// =======================

  // Simpan list ke SharedPreferences
  Future<void> _saveHabitsToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String encodedData = jsonEncode(
        _habits.map((habit) => habit.toJson()).toList(),
      );
      await prefs.setString(_storageKey, encodedData);
    } catch (e) {
      debugPrint('Gagal menyimpan habits: $e');
    }
  }

  // Muat list dari SharedPreferences
  Future<void> _loadHabitsFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? habitsString = prefs.getString(_storageKey);

      if (habitsString != null) {
        final List<dynamic> decodedData = jsonDecode(habitsString);
        _habits = decodedData
            .map((item) => HabitModel.fromJson(item as Map<String, dynamic>))
            .toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Gagal memuat habits: $e');
    }
  }

  /// =======================
  /// GET HABIT BY MONTH
  /// =======================

  List<HabitModel> getHabitsByMonth(
    DateTime month,
  ) {
    return _habits.where((habit) {
      return habit.createdAt.month == month.month &&
          habit.createdAt.year == month.year;
    }).toList();
  }

  /// =========================
  /// TOTAL HABIT HARI INI / AKTIF
  /// =========================

  int get totalHabits => _habits.length;

  /// =========================
  /// COMPLETED HABIT HARI INI
  /// =========================

  int get completedHabits => _habits.where((habit) => habit.completed).length;

  /// =========================
  /// TOTAL SELESAI SEMUA HABIT (AKURAT)
  /// =========================

  int get totalCompletedAllTime =>
      _habits.where((habit) => habit.completed).length;

  /// =========================
  /// HITUNG STREAK (AKURAT)
  /// =========================

  int get currentStreak {
    if (_habits.isEmpty) return 0;

    // Kumpulkan tanggal-tanggal unik saat habit diselesaikan
    final completedDates = _habits
        .where((habit) => habit.completed)
        .map((habit) => DateTime(
              habit.createdAt.year,
              habit.createdAt.month,
              habit.createdAt.day,
            ))
        .toSet()
        .toList();

    if (completedDates.isEmpty) return 0;

    // Urutkan dari tanggal terbaru ke terlama
    completedDates.sort((a, b) => b.compareTo(a));

    final today = DateTime.now();
    final todayNormalized = DateTime(today.year, today.month, today.day);
    final yesterdayNormalized =
        todayNormalized.subtract(const Duration(days: 1));

    // Periksa apakah ada habit selesai hari ini atau kemarin
    if (!completedDates.contains(todayNormalized) &&
        !completedDates.contains(yesterdayNormalized)) {
      return 0;
    }

    int streak = 0;
    DateTime checkDate = completedDates.contains(todayNormalized)
        ? todayNormalized
        : yesterdayNormalized;

    while (completedDates.contains(checkDate)) {
      streak++;
      checkDate = checkDate.subtract(const Duration(days: 1));
    }

    return streak;
  }

  /// =========================
  /// PERCENT
  /// =========================

  double get progressPercent {
    if (_habits.isEmpty) {
      return 0;
    }

    return completedHabits / totalHabits;
  }

  /// =========================
  /// ADD
  /// =========================

  void addHabit(
    HabitModel habit,
  ) {
    _habits.add(habit);
    _saveHabitsToStorage(); // Simpan perubahan
    notifyListeners();
  }

  /// =========================
  /// TOGGLE
  /// =========================

  void toggleHabit(
    HabitModel habit,
  ) {
    final index = _habits.indexOf(habit);

    if (index == -1) {
      return;
    }

    _habits[index].completed = !_habits[index].completed;
    _saveHabitsToStorage(); // Simpan perubahan
    notifyListeners();
  }

  /// =========================
  /// UPDATE / EDIT
  /// =========================

  void updateHabit(
    HabitModel oldHabit,
    HabitModel updatedHabit,
  ) {
    final index = _habits.indexOf(oldHabit);

    if (index == -1) {
      return;
    }

    _habits[index] = updatedHabit;
    _saveHabitsToStorage(); // Simpan perubahan
    notifyListeners();
  }

  /// =========================
  /// DELETE
  /// =========================

  void deleteHabit(
    HabitModel habit,
  ) {
    _habits.remove(habit);
    _saveHabitsToStorage(); // Simpan perubahan
    notifyListeners();
  }

  /// =========================
  /// GET HABITS BY DATE
  /// =========================

  List<HabitModel> getHabitsByDate(
    DateTime date,
  ) {
    return _habits.where((habit) {
      return habit.createdAt.year == date.year &&
          habit.createdAt.month == date.month &&
          habit.createdAt.day == date.day;
    }).toList();
  }

  /// =========================
  /// COMPLETED BY DATE
  /// =========================

  int completedHabitsByDate(
    DateTime date,
  ) {
    return getHabitsByDate(date).where((habit) => habit.completed).length;
  }

  /// =========================
  /// TOTAL BY DATE
  /// =========================

  int totalHabitsByDate(
    DateTime date,
  ) {
    return getHabitsByDate(date).length;
  }
}
