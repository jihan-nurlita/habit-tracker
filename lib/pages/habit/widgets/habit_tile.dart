import 'package:flutter/material.dart';
import 'package:habit_tracker/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class HabitTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String schedule;
  final bool completed;
  final VoidCallback onTap;

  const HabitTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.schedule,
    required this.completed,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(
      context,
    ).currentTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            /// ICON
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: theme.softColor,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(
                icon,
                size: 28,
                color: theme.primaryColor,
              ),
            ),

            const SizedBox(width: 16),

            /// TEXT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: theme.textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 0),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: theme.textColor
                          .withOpacity(0.55), // Samar sesuai tema
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    schedule,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            /// CHECK BUTTON
            GestureDetector(
              onTap: onTap,
              child: Icon(
                completed ? Icons.check_circle : Icons.radio_button_unchecked,
                color: completed ? theme.primaryColor : theme.borderColor,
                size: 34,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
