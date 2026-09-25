import 'package:flutter/material.dart';
import 'package:habit_tracker/pages/auth/providers/auth_provider.dart';
import 'package:habit_tracker/pages/home/home_page.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
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
                      32, // Konten otomatis memenuhi layar
                ),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),

                      /// ILLUSTRATION (Responsif sesuai proporsi layar)
                      Image.asset(
                        'assets/images/auth_illustration.png',
                        height: (screenHeight * 0.22).clamp(140.0, 220.0),
                        fit: BoxFit.contain,
                      ),

                      SizedBox(height: screenHeight * 0.03),

                      /// CARD
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
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              "Create Account ✨",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "Start building better habits today",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 24),

                            /// NAME
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

                            /// EMAIL
                            TextField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
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

                            /// REGISTER BUTTON
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xff4CAF6A),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                ),
                                onPressed: () async {
                                  if (nameController.text.trim().isEmpty ||
                                      emailController.text.trim().isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text("Nama dan Email wajib diisi"),
                                      ),
                                    );
                                    return;
                                  }

                                  await context.read<AuthProvider>().login(
                                        name: nameController.text.trim(),
                                        email: emailController.text.trim(),
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
                                  "Create Account",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),

                            /// LOGIN LINK
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Already have an account?",
                                  style: TextStyle(fontSize: 13),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    "Login",
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
