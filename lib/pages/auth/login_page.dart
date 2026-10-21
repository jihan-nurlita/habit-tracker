import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:habit_tracker/pages/auth/providers/auth_provider.dart';
import 'package:habit_tracker/providers/theme_provider.dart';
import '../home/home_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;
  bool obscurePassword = true; // Untuk kontrol show/hide password

  @override
  void dispose() {
    emailController.dispose();
    nameController.dispose();
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

  Future<void> _handleLogin() async {
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

    // 5. Cek minimal panjang password (minimal 6 karakter)
    if (password.length < 6) {
      _showWarning("Password minimal harus 6 karakter");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Simpan data auth ke Provider
      await context.read<AuthProvider>().login(
            name: name,
            email: email,
          );

      // Simpan status session login
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_logged_in', true);

      if (!mounted) return;

      // Pindah ke Home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const HomePage(),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      _showWarning("Gagal melakukan login. Silakan coba lagi.");
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

                      // Card Form Login
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
                              "Welcome Back",
                              style: GoogleFonts.poppins(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: theme.textColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Track your habits and stay productive",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                color: theme.textColor.withOpacity(0.6),
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 24),

                            // INPUT NAME
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

                            // INPUT EMAIL
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

                            // INPUT PASSWORD
                            TextField(
                              controller: passwordController,
                              obscureText: obscurePassword,
                              textInputAction: TextInputAction.done,
                              onSubmitted: (_) => _handleLogin(),
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

                            // LOGIN BUTTON
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
                                onPressed: isLoading ? null : _handleLogin,
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
                                        "Login",
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 12),

                            // REGISTER LINK
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Don't have an account?",
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: theme.textColor.withOpacity(0.7),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const RegisterPage(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "Register",
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
