import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:habit_tracker/core/theme/theme_data.dart';
import 'package:habit_tracker/pages/auth/login_page.dart';
import 'package:habit_tracker/pages/auth/providers/auth_provider.dart';
import 'package:habit_tracker/pages/calendar/calendar_page.dart';
import 'package:habit_tracker/pages/focus/focus_page.dart';
import 'package:habit_tracker/pages/habit/habit_page.dart';
import 'package:habit_tracker/pages/home/home_page.dart';
import 'package:habit_tracker/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(
      context,
    ).currentTheme;

    final auth = Provider.of<AuthProvider>(
      context,
    );

    return Scaffold(
      backgroundColor: theme.backgroundColor,

      /// =========================
      /// BOTTOM NAVBAR
      /// =========================
      bottomNavigationBar: const _BottomNavbar(
        currentIndex: 4,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                /// =========================
                /// PROFILE HEADER
                /// =========================
                const SizedBox(height: 10),

                CircleAvatar(
                  radius: 52,
                  backgroundColor: theme.softColor,
                  child: Text(
                    auth.name.isNotEmpty ? auth.name[0].toUpperCase() : "U",
                    style: GoogleFonts.poppins(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: theme.primaryColor,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  auth.name,
                  style: GoogleFonts.poppins(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                    color: theme.textColor,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  auth.email,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: theme.iconColor.withOpacity(0.55),
                  ),
                ),

                const SizedBox(height: 34),

                /// =========================
                /// MENU LIST
                /// =========================
                _buildMenuTile(
                  context: context,
                  icon: Icons.person_outline_rounded,
                  title: "Edit Profile",
                  theme: theme,
                  onTap: () {},
                ),

                const SizedBox(height: 14),

                _buildMenuTile(
                  context: context,
                  icon: Icons.settings_outlined,
                  title: "Pengaturan",
                  theme: theme,
                  onTap: () {},
                ),

                const SizedBox(height: 14),

                /// MODE LIGHT/DARK
                _buildMenuTile(
                  context: context,
                  icon: Icons.dark_mode_rounded,
                  title: "Mode Aplikasi",
                  theme: theme,
                  onTap: () {
                    _showModeBottomSheet(
                      context,
                      theme,
                    );
                  },
                ),

                const SizedBox(height: 14),

                /// COLOR
                _buildMenuTile(
                  context: context,
                  icon: Icons.palette_outlined,
                  title: "Warna Tema",
                  theme: theme,
                  onTap: () {
                    _showColorThemeBottomSheet(
                      context,
                      theme,
                    );
                  },
                ),

                const SizedBox(height: 14),

                _buildMenuTile(
                  context: context,
                  icon: Icons.cloud_upload_outlined,
                  title: "Backup & Sync",
                  theme: theme,
                  onTap: () {},
                ),

                const SizedBox(height: 14),

                _buildMenuTile(
                  context: context,
                  icon: Icons.help_outline_rounded,
                  title: "Bantuan & Feedback",
                  theme: theme,
                  onTap: () {},
                ),

                const SizedBox(height: 14),

                /// KELUAR / LOGOUT
                _buildMenuTile(
                  context: context,
                  icon: Icons.logout_rounded,
                  title: "Keluar",
                  theme: theme,
                  onTap: () async {
                    await context.read<AuthProvider>().logout();

                    if (!context.mounted) return;

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LoginPage(),
                      ),
                      (route) => false,
                    );
                  },
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// =========================
  /// MENU TILE
  /// =========================
  Widget _buildMenuTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required dynamic theme,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.grey.shade200,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 28,
              color: Colors.grey.shade400,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: theme.textColor,
                ),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_right_rounded,
              size: 30,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }

  /// =========================
  /// BOTTOMSHEET MODE
  /// =========================
  void _showModeBottomSheet(
    BuildContext context,
    dynamic theme,
  ) {
    final themeProvider = Provider.of<ThemeProvider>(
      context,
      listen: false,
    );

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(22),
          margin: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(32),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// HANDLE BAR (Garis kecil di atas)
              Container(
                width: 60,
                height: 5,
                decoration: BoxDecoration(
                  color: theme.textColor.withOpacity(
                      0.2), // Mengikuti warna teks dengan transparansi
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              Container(
                width: 60,
                height: 5,
                decoration: BoxDecoration(
                  color: theme
                      .cardColor, // 👈 Background bottom sheet sesuai mode (Light / Dark)
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              const SizedBox(height: 15),
              Text(
                "Mode Aplikasi",
                style: GoogleFonts.poppins(
                  color: theme.textColor,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              _buildThemeItem(
                title: "Light Mode",
                icon: Icons.light_mode_rounded,
                theme: theme,
                onTap: () {
                  themeProvider.setDarkMode(false);
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 14),
              _buildThemeItem(
                title: "Dark Mode",
                icon: Icons.dark_mode_rounded,
                theme: theme,
                onTap: () {
                  themeProvider.setDarkMode(true);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// =========================
  /// BOTTOMSHEET COLOR
  /// =========================

  void _showColorThemeBottomSheet(
    BuildContext context,
    dynamic theme,
  ) {
    final themeProvider = Provider.of<ThemeProvider>(
      context,
      listen: false,
    );

    final themes = [
      greenTheme,
      redTheme,
      orangeTheme,
      yellowTheme,
      purpleTheme,
      indigoTheme,
      pinkTheme,
      roseTheme,
      blueTheme,
      oceanTheme,
      mintTheme,
      brownTheme,
      greyTheme,
      darkTheme,
      lavenderTheme,
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor:
          Colors.transparent, // Agar rounded corner background terlihat
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(22),
          margin: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme
                .cardColor, // 👈 Background bottom sheet sesuai mode (Light / Dark)
            borderRadius: BorderRadius.circular(32),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// HANDLE BAR (Garis kecil di atas)
              Container(
                width: 60,
                height: 5,
                decoration: BoxDecoration(
                  color: theme.textColor.withOpacity(
                      0.2), // Mengikuti warna teks dengan transparansi
                  borderRadius: BorderRadius.circular(20),
                ),
              ),

              const SizedBox(height: 20),

              /// JUDUL
              Text(
                "Pilih Warna Tema",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color:
                      theme.textColor, // 👈 Teks menyesuaikan Light / Dark Mode
                ),
              ),

              const SizedBox(height: 16),

              /// GRID PILIHAN WARNA
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: themes.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5, // Ditampilkan 5 kolom agar muat dan rapi
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  final item = themes[index];

                  return GestureDetector(
                    onTap: () {
                      themeProvider.changeTheme(item);
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: item.primaryColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: theme
                              .borderColor, // 👈 Border lingkaran menyesuaikan mode
                          width: 2,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// =========================
  /// THEME ITEM
  /// =========================
  Widget _buildThemeItem({
    required String title,
    required IconData icon,
    required dynamic theme,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: theme.softColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: theme.primaryColor,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  color: theme.textColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 17,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 18,
              color: theme.primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}

/// =========================
/// BOTTOM NAVBAR
/// =========================
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
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const HomePage(),
              ),
            );
            break;
          case 1:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const HabitPage(),
              ),
            );
            break;
          case 2:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const FocusPage(),
              ),
            );
            break;
          case 3:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const CalendarPage(),
              ),
            );
            break;
          case 4:
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_rounded),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.task_alt_rounded),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.timer_outlined),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month_rounded),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_rounded),
          label: '',
        ),
      ],
    );
  }
}
