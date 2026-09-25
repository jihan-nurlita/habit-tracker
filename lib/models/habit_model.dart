import 'package:flutter/material.dart';

class HabitModel {
  final IconData icon;
  final String title;
  final String subtitle;
  final String notes;
  final String category;
  final String startTime;
  final String endTime;
  final String duration;
  final String target;
  final String repeat;
  final bool reminderEnabled;

  /// TAMBAHAN
  final DateTime date;
  bool completed;
  final DateTime createdAt;

  HabitModel({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.notes,
    required this.category,
    required this.startTime,
    required this.endTime,
    required this.duration,
    required this.target,
    required this.repeat,
    required this.reminderEnabled,
    required this.date,
    this.completed = false,
    required this.createdAt,
  });

  HabitModel copyWith({
    IconData? icon,
    String? title,
    String? subtitle,
    String? notes,
    String? category,
    String? startTime,
    String? endTime,
    String? duration,
    String? target,
    String? repeat,
    bool? reminderEnabled,
    DateTime? date,
    bool? completed,
    DateTime? createdAt,
  }) {
    return HabitModel(
      icon: icon ?? this.icon,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      notes: notes ?? this.notes,
      category: category ?? this.category,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      duration: duration ?? this.duration,
      target: target ?? this.target,
      repeat: repeat ?? this.repeat,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      date: date ?? this.date,
      completed: completed ?? this.completed,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// ==========================================
  /// CONVERT OBJECT TO JSON (MAP)
  /// ==========================================
  Map<String, dynamic> toJson() {
    return {
      'iconCodePoint': icon.codePoint,
      'iconFontFamily': icon.fontFamily,
      'title': title,
      'subtitle': subtitle,
      'notes': notes,
      'category': category,
      'startTime': startTime,
      'endTime': endTime,
      'duration': duration,
      'target': target,
      'repeat': repeat,
      'reminderEnabled': reminderEnabled,
      'date': date.toIso8601String(),
      'completed': completed,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// ==========================================
  /// CREATE OBJECT FROM JSON (MAP)
  /// ==========================================
  factory HabitModel.fromJson(Map<String, dynamic> json) {
    return HabitModel(
      icon: IconData(
        json['iconCodePoint'] ?? Icons.task_alt.codePoint,
        fontFamily: json['iconFontFamily'] ?? 'MaterialIcons',
      ),
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      notes: json['notes'] ?? '',
      category: json['category'] ?? '',
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      duration: json['duration'] ?? '',
      target: json['target'] ?? '',
      repeat: json['repeat'] ?? '',
      reminderEnabled: json['reminderEnabled'] ?? false,
      date:
          json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      completed: json['completed'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }
}
