import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:habit_tracker/pages/auth/providers/auth_provider.dart';
import 'package:habit_tracker/pages/home/home_page.dart';
import 'package:habit_tracker/providers/theme_provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;
  bool obscurePassword = true;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // Helper untuk menampilkan SnackBar Peringatan
  void _showWarning(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  // Helper untuk cek format email valid
  bool _isEmailValid(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
    );
    return emailRegex.hasMatch(email.trim());
  }

  Future<void> _handleRegister() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // 1. Cek jika nama kosong
    if (name.isEmpty) {
      _showWarning("Harap masukkan nama Anda");
      return;
    }

    // 2. Cek jika email kosong
    if (email.isEmpty) {
      _showWarning("Harap masukkan alamat email");
      return;
    }

    // 3. Cek apakah format email benar
    if (!_isEmailValid(email)) {
      _showWarning("Format email tidak valid (contoh: nama@email.com)");
      return;
    }

    // 4. Cek jika password kosong
    if (password.isEmpty) {
      _showWarning("Harap masukkan password Anda");
      return;
    }

    // 5. Cek panjang password minimal
    if (password.length < 6) {
      _showWarning("Password minimal harus 6 karakter");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Simpan akun ke AuthProvider
      await context.read<AuthProvider>().login(
            name: name,
            email: email,
          );

      // Simpan status session login agar otomatis masuk Home di kemudian hari
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_logged_in', true);

      if (!mounted) return;

      // Masuk ke HomePage dan hapus tumpukan halaman sebelumnya
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const HomePage(),
        ),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      _showWarning("Gagal membuat akun. Silakan coba lagi.");
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Mengambil tema aktif agar otomatis menyesuaikan Light / Dark Mode
    final theme = Provider.of<ThemeProvider>(context).currentTheme;

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 32,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),

                      // =========================
                      // ICON HEADER
                      // =========================
                      Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          color: theme.primaryColor.withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: theme.primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.lock_outline_rounded,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      // =========================
                      // CARD FORM REGISTER
                      // =========================
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 20,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // NAMA APLIKASI
                            Text(
                              "Habit Tracker",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: theme.primaryColor,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Create Account",
                              style: GoogleFonts.poppins(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: theme.textColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Start building better habits today",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                color: theme.textColor.withOpacity(0.6),
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 24),

                            // NAME FIELD
                            TextField(
                              controller: nameController,
                              textInputAction: TextInputAction.next,
                              style: GoogleFonts.poppins(
                                color: theme.textColor,
                              ),
                              decoration: InputDecoration(
                                hintText: "Your Name",
                                hintStyle: TextStyle(
                                  color: theme.textColor.withOpacity(0.4),
                                ),
                                prefixIcon: Icon(
                                  Icons.person_outline,
                                  color: theme.primaryColor,
                                ),
                                filled: true,
                                fillColor: theme.backgroundColor,
                                // Border saat tidak diketuk
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: BorderSide.none,
                                ),
                                // Border aktif saat TextField diketuk (Focused)
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: BorderSide(
                                    color: theme.primaryColor,
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // EMAIL FIELD
                            TextField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              style: GoogleFonts.poppins(
                                color: theme.textColor,
                              ),
                              decoration: InputDecoration(
                                hintText: "Your Email",
                                hintStyle: TextStyle(
                                  color: theme.textColor.withOpacity(0.4),
                                ),
                                prefixIcon: Icon(
                                  Icons.email_outlined,
                                  color: theme.primaryColor,
                                ),
                                filled: true,
                                fillColor: theme.backgroundColor,
                                // Border saat tidak diketuk
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: BorderSide.none,
                                ),
                                // Border aktif saat TextField diketuk (Focused)
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: BorderSide(
                                    color: theme.primaryColor,
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // PASSWORD FIELD
                            TextField(
                              controller: passwordController,
                              obscureText: obscurePassword,
                              textInputAction: TextInputAction.done,
                              onSubmitted: (_) => _handleRegister(),
                              style: GoogleFonts.poppins(
                                color: theme.textColor,
                              ),
                              decoration: InputDecoration(
                                hintText: "Password",
                                hintStyle: TextStyle(
                                  color: theme.textColor.withOpacity(0.4),
                                ),
                                prefixIcon: Icon(
                                  Icons.lock_outline,
                                  color: theme.primaryColor,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    obscurePassword
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: theme.textColor.withOpacity(0.6),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      obscurePassword = !obscurePassword;
                                    });
                                  },
                                ),
                                filled: true,
                                fillColor: theme.backgroundColor,
                                // Border saat tidak diketuk
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: BorderSide.none,
                                ),
                                // Border aktif saat TextField diketuk (Focused)
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: BorderSide(
                                    color: theme.primaryColor,
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),

                            // REGISTER BUTTON
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: theme.primaryColor,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                ),
                                onPressed: isLoading ? null : _handleRegister,
                                child: isLoading
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2.5,
                                        ),
                                      )
                                    : Text(
                                        "Create Account",
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 12),

                            // LOGIN LINK
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Already have an account?",
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: theme.textColor.withOpacity(0.7),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "Login",
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: theme.primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
