import 'package:flutter/material.dart';
import 'package:habit_tracker/pages/auth/providers/auth_provider.dart';
import 'package:provider/provider.dart';

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

  @override
  void dispose() {
    emailController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;

    return Scaffold(
      backgroundColor: const Color(0xffF6FBF7),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight -
                      32, // Memastikan konten mengisi tinggi layar penuh jika memungkinkan
                ),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),
                      // Gambar Ilustrasi yang ukurannya menyesuaikan tinggi layar HP (maksimal 220px)
                      Image.asset(
                        'assets/images/auth_illustration.png',
                        height: (screenHeight * 0.22).clamp(140.0, 220.0),
                        fit: BoxFit.contain,
                      ),
                      SizedBox(height: screenHeight * 0.03),

                      // Card Form Login
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(.05),
                              blurRadius: 20,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              "Welcome Back 👋",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "Track your habits and stay productive",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 24),
                            TextField(
                              controller: nameController,
                              decoration: InputDecoration(
                                hintText: "Your Name",
                                prefixIcon: const Icon(Icons.person_outline),
                                filled: true,
                                fillColor: const Color(0xffF7F7F7),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: emailController,
                              decoration: InputDecoration(
                                hintText: "Your Email",
                                prefixIcon: const Icon(Icons.email_outlined),
                                filled: true,
                                fillColor: const Color(0xffF7F7F7),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xff4CAF6A),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                ),
                                onPressed: () async {
                                  if (nameController.text.isEmpty ||
                                      emailController.text.isEmpty) {
                                    return;
                                  }

                                  await context.read<AuthProvider>().login(
                                        name: nameController.text,
                                        email: emailController.text,
                                      );

                                  if (!context.mounted) return;

                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const HomePage(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  "Login",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Don't have an account?",
                                  style: TextStyle(fontSize: 13),
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
                                  child: const Text(
                                    "Register",
                                    style: TextStyle(fontSize: 13),
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
