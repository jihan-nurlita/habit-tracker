import 'dart:async';
import 'package:flutter/material.dart';

class FocusProvider extends ChangeNotifier {
  /// =========================
  /// MODES
  /// =========================
  final List<FocusMode> modes = [
    FocusMode(
      title: "Pomodoro",
      minutes: 25,
    ),
    FocusMode(
      title: "Deep Work",
      minutes: 50,
    ),
    FocusMode(
      title: "Relax",
      minutes: 10,
    ),
  ];

  int selectedMode = 0;

  Timer? _timer;

  bool isRunning = false;

  late int totalSeconds;
  late int remainingSeconds;

  /// TOTAL FOCUS TODAY
  int totalFocusToday = 0;

  FocusProvider() {
    _initializeMode();
  }

  /// =========================
  /// INIT MODE
  /// =========================
  void _initializeMode() {
    totalSeconds = modes[selectedMode].minutes * 60;
    remainingSeconds = totalSeconds;
  }

  /// =========================
  /// CHANGE MODE
  /// =========================
  void changeMode(int index) {
    selectedMode = index;

    _timer?.cancel();
    isRunning = false;

    totalSeconds = modes[index].minutes * 60;
    remainingSeconds = totalSeconds;

    notifyListeners();
  }

  /// =========================
  /// START TIMER
  /// =========================
  void startFocus() {
    if (isRunning) return;

    isRunning = true;

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (remainingSeconds > 0) {
          remainingSeconds--;

          /// hitung focus hari ini
          totalFocusToday++;

          notifyListeners();
        } else {
          stopFocus();
        }
      },
    );

    notifyListeners();
  }

  /// =========================
  /// PAUSE
  /// =========================
  void pauseFocus() {
    _timer?.cancel();
    isRunning = false;
    notifyListeners();
  }

  /// =========================
  /// RESET
  /// =========================
  void resetFocus() {
    _timer?.cancel();

    isRunning = false;
    remainingSeconds = totalSeconds;

    notifyListeners();
  }

  /// =========================
  /// STOP
  /// =========================
  void stopFocus() {
    _timer?.cancel();
    isRunning = false;
    notifyListeners();
  }

  /// =========================
  /// FORMAT TIME
  /// =========================
  String get formattedTime {
    final minutes = (remainingSeconds ~/ 60).toString().padLeft(2, '0');

    final seconds = (remainingSeconds % 60).toString().padLeft(2, '0');

    return "$minutes:$seconds";
  }

  /// =========================
  /// PROGRESS
  /// =========================
  double get progress {
    return remainingSeconds / totalSeconds;
  }

  /// =========================
  /// TOTAL FOCUS HOURS
  /// =========================
  String get totalFocusHours {
    final hours = totalFocusToday / 3600;

    return hours.toStringAsFixed(1);
  }

  FocusMode get currentMode => modes[selectedMode];

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

class FocusMode {
  final String title;
  final int minutes;

  FocusMode({
    required this.title,
    required this.minutes,
  });
}
