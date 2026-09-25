import 'dart:async';

import 'package:flutter/material.dart';
import 'package:habit_tracker/pages/auth/login_page.dart';
import 'package:habit_tracker/pages/auth/providers/auth_provider.dart';
import 'package:habit_tracker/pages/home/home_page.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    Timer(
      const Duration(seconds: 3),
      () {
        final auth = context.read<AuthProvider>();

        if (auth.isLogin) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const HomePage(),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const LoginPage(),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6FBF7),
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),

            /// LOGO
            Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                color: const Color(0xffDDF5E5),
                borderRadius: BorderRadius.circular(
                  36,
                ),
              ),
              child: const Icon(
                Icons.auto_graph_rounded,
                size: 70,
                color: Color(0xff4CAF6A),
              ),
            ),

            const SizedBox(height: 30),

            /// APP NAME
            const Text(
              "Habit Tracker",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
                color: Color(0xff1E1E1E),
              ),
            ),

            const SizedBox(height: 10),

            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 40,
              ),
              child: Text(
                "Build better habits, stay consistent, and achieve your goals every day.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  height: 1.6,
                  color: Colors.grey,
                ),
              ),
            ),

            const Spacer(),

            /// LOADING
            const CircularProgressIndicator(
              strokeWidth: 3,
              color: Color(0xff4CAF6A),
            ),

            const SizedBox(height: 20),

            const Text(
              "Loading...",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
