import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:habit_tracker/pages/auth/login_page.dart';
import 'package:habit_tracker/pages/home/home_page.dart';
import 'package:habit_tracker/pages/onboarding/onboarding_page.dart';
import 'package:habit_tracker/providers/theme_provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  // Fungsi untuk mengecek status login & onboarding
  Future<void> _checkAuthStatus() async {
    // Berikan jeda waktu tampil splash screen (misal 2 detik)
    await Future.delayed(const Duration(seconds: 2));

    final prefs = await SharedPreferences.getInstance();
    final bool isFirstRun = prefs.getBool('is_first_run') ?? true;
    final bool isLoggedIn = prefs.getBool('is_logged_in') ?? false;

    if (!mounted) return;

    // Logika Pengalihan Halaman
    if (isFirstRun) {
      // Jika pertama kali buka aplikasi -> ke Onboarding
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnboardingPage()),
      );
    } else if (isLoggedIn) {
      // Jika sudah pernah login -> langsung ke Home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } else {
      // Jika sudah bukan pertama kali tapi belum login -> ke Login Page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Mengambil tema aktif dari ThemeProvider agar otomatis mengikuti Light / Dark Mode
    final theme = Provider.of<ThemeProvider>(context).currentTheme;

    return Scaffold(
      backgroundColor: theme.backgroundColor, // Berubah otomatis sesuai mode
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo / Icon Utama Aplikasi
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: theme.primaryColor.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: theme.primaryColor, // Mengikuti warna tema utama
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.task_alt_rounded,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "Habit Tracker",
              style: GoogleFonts.poppins(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: theme.textColor, // Otomatis menyesuaikan teks Light/Dark
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Build Better Habits Every Day",
              style: GoogleFonts.poppins(
                fontSize: 14,
                color:
                    theme.textColor.withOpacity(0.6), // Otomatis menyesuaikan
              ),
            ),
          ],
        ),
      ),
    );
  }
}
