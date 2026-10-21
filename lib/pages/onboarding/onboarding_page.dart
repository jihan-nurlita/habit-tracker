import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:habit_tracker/pages/auth/login_page.dart';
import 'package:habit_tracker/providers/theme_provider.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController controller = PageController();
  bool isLastPage = false;

  final List<OnboardingModel> pages = const [
    OnboardingModel(
      icon: Icons.task_alt_rounded,
      title: 'Mulai Bangun Kebiasaan',
      description:
          'Pantau rutinitas harianmu, selesaikan target, dan bangun kebiasaan positif setiap hari.',
    ),
    OnboardingModel(
      icon: Icons.timer_outlined,
      title: 'Fokus & Kelola Waktu',
      description:
          'Gunakan fitur timer dan sesi fokus untuk meningkatkan produktivitas belajar atau bekerja.',
    ),
    OnboardingModel(
      icon: Icons.calendar_month_rounded,
      title: 'Pantau Progres Harian',
      description:
          'Lihat perkembangan konsistensimu melalui kalender dan statistik pencapaian habit.',
    ),
  ];

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> finishOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_first_run', false);

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  void nextPage() {
    if (isLastPage) {
      finishOnboarding();
      return;
    }

    controller.nextPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Mengambil tema aktif dari ThemeProvider agar sinkron dengan Light/Dark Mode & warna pilihan user
    final theme = Provider.of<ThemeProvider>(context).currentTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          theme.backgroundColor, // Otomatis menyesuaikan Light/Dark
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 16),

              // =========================
              // TOMBOL LEWATI (SKIP)
              // =========================
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: finishOnboarding,
                  child: Text(
                    'Lewati',
                    style: GoogleFonts.poppins(
                      color: theme.textColor.withOpacity(0.6),
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              // =========================
              // PAGEVIEW CONTENT
              // =========================
              Expanded(
                child: PageView.builder(
                  controller: controller,
                  itemCount: pages.length,
                  onPageChanged: (index) {
                    setState(() {
                      isLastPage = index == pages.length - 1;
                    });
                  },
                  itemBuilder: (context, index) {
                    final page = pages[index];

                    return Column(
                      children: [
                        const SizedBox(height: 20),

                        // ICON LINGKARAN DENGAN SOFT BACKGROUND
                        Expanded(
                          flex: 6,
                          child: Center(
                            child: Container(
                              width: 230,
                              height: 230,
                              decoration: BoxDecoration(
                                color: theme.primaryColor
                                    .withOpacity(isDark ? 0.18 : 0.10),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Container(
                                  width: 160,
                                  height: 160,
                                  decoration: BoxDecoration(
                                    color: theme.primaryColor,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: theme.primaryColor
                                            .withOpacity(0.25),
                                        blurRadius: 30,
                                        offset: const Offset(0, 12),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    page.icon,
                                    size: 80,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // TITLE
                        Text(
                          page.title,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: theme.textColor,
                            height: 1.2,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // DESCRIPTION
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            page.description,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              height: 1.6,
                              color: theme.textColor.withOpacity(0.7),
                            ),
                          ),
                        ),

                        const Spacer(),
                      ],
                    );
                  },
                ),
              ),

              // =========================
              // INDICATOR TITIK (SMOOTH)
              // =========================
              SmoothPageIndicator(
                controller: controller,
                count: pages.length,
                effect: ExpandingDotsEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  spacing: 8,
                  activeDotColor: theme.primaryColor,
                  dotColor:
                      isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                ),
              ),

              const SizedBox(height: 32),

              // =========================
              // TOMBOL UTAMA
              // =========================
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: nextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: Text(
                    isLastPage ? 'Mulai Sekarang' : 'Selanjutnya',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardingModel {
  final IconData icon;
  final String title;
  final String description;

  const OnboardingModel({
    required this.icon,
    required this.title,
    required this.description,
  });
}
