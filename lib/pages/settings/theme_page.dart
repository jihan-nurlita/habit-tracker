import 'package:flutter/material.dart';
import 'package:habit_tracker/core/theme/theme_data.dart';
import 'package:habit_tracker/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/theme_model.dart';

class ThemePage extends StatelessWidget {
  const ThemePage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    final List<ThemeModel> themes = [
      greenTheme,
      purpleTheme,
      pinkTheme,
      blueTheme,
      orangeTheme,
      greyTheme,
      redTheme,
      cyanTheme,
      yellowTheme,
      mintTheme,
      indigoTheme,
      brownTheme,
      roseTheme,
      lavenderTheme,
      oceanTheme,
      darkTheme,
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pilih Tema"),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: themes.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemBuilder: (context, index) {
          final theme = themes[index];

          return GestureDetector(
            onTap: () {
              themeProvider.changeTheme(theme);
            },
            child: Container(
              decoration: BoxDecoration(
                color: theme.primaryColor,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Center(
                child: CircleAvatar(
                  backgroundColor: theme.softColor,
                  child: Icon(
                    Icons.palette_rounded,
                    color: theme.iconColor,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
