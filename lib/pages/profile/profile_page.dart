import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:habit_tracker/pages/navigation/custom_bottom_nav.dart';
import 'package:provider/provider.dart';
import 'package:habit_tracker/core/theme/theme_data.dart';
import 'package:habit_tracker/pages/auth/login_page.dart';
import 'package:habit_tracker/pages/auth/providers/auth_provider.dart';
import 'package:habit_tracker/providers/theme_provider.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  // Pop-up Dialog Konfirmasi Keluar
  void _showLogoutDialog(BuildContext context, dynamic theme) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: theme.cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        title: Row(
          children: [
            Text(
              "Konfirmasi Keluar",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: theme.textColor,
              ),
            ),
          ],
        ),
        content: Text(
          "Apakah Anda yakin ingin keluar dari akun ini?",
          style: GoogleFonts.poppins(
            fontSize: 15,
            color: theme.textColor.withOpacity(0.8),
          ),
        ),
        actionsPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              "Batal",
              style: GoogleFonts.poppins(
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () async {
              Navigator.pop(ctx);
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
            child: Text(
              "Keluar",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget Tampilan Avatar Dinamis (Mendukung Foto, Icon Person, atau Inisial)
  Widget _buildAvatarDisplay(AuthProvider auth, dynamic theme) {
    if (auth.profileImagePath != null && auth.profileImagePath!.isNotEmpty) {
      return CircleAvatar(
        radius: 52,
        backgroundImage: FileImage(File(auth.profileImagePath!)),
      );
    } else if (auth.useDefaultIcon) {
      return CircleAvatar(
        radius: 52,
        backgroundColor: theme.softColor,
        child: Icon(
          Icons.person_rounded,
          size: 50,
          color: theme.primaryColor,
        ),
      );
    } else {
      return CircleAvatar(
        radius: 52,
        backgroundColor: theme.softColor,
        child: Text(
          auth.initialName,
          style: GoogleFonts.poppins(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: theme.primaryColor,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).currentTheme;
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      bottomNavigationBar: const CustomBottomNav(currentIndex: 4),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 10),

                // Avatar Profil Utama
                _buildAvatarDisplay(auth, theme),

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

                // Menu List
                _buildMenuTile(
                  context: context,
                  icon: Icons.person_outline_rounded,
                  title: "Edit Profile",
                  theme: theme,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const EditProfilePage(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 14),

                _buildMenuTile(
                  context: context,
                  icon: Icons.dark_mode_rounded,
                  title: "Mode Aplikasi",
                  theme: theme,
                  onTap: () {
                    _showModeBottomSheet(context, theme);
                  },
                ),

                const SizedBox(height: 14),

                _buildMenuTile(
                  context: context,
                  icon: Icons.palette_outlined,
                  title: "Warna Tema",
                  theme: theme,
                  onTap: () {
                    _showColorThemeBottomSheet(context, theme);
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

                _buildMenuTile(
                  context: context,
                  icon: Icons.logout_rounded,
                  title: "Keluar",
                  theme: theme,
                  onTap: () => _showLogoutDialog(context, theme),
                ),

                const SizedBox(height: 7),
              ],
            ),
          ),
        ),
      ),
    );
  }

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
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Icon(icon, size: 28, color: Colors.grey.shade400),
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

  void _showModeBottomSheet(BuildContext context, dynamic theme) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

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
              Container(
                width: 60,
                height: 5,
                decoration: BoxDecoration(
                  color: theme.textColor.withOpacity(0.2),
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

  void _showColorThemeBottomSheet(BuildContext context, dynamic theme) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

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
              Container(
                width: 60,
                height: 5,
                decoration: BoxDecoration(
                  color: theme.textColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Pilih Warna Tema",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: theme.textColor,
                ),
              ),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: themes.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
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
            Icon(icon, color: theme.primaryColor),
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
            Icon(Icons.arrow_forward_ios_rounded,
                size: 18, color: theme.primaryColor),
          ],
        ),
      ),
    );
  }
}
