import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_page.dart'; // Ensure this matches your login page file name

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // 12-second timer to navigate
    Timer(const Duration(seconds: 12), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020202),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ASYMMETRIC FRAME
            Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(80),
                  bottomRight: Radius.circular(80),
                ),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1),
              ),
              padding: const EdgeInsets.all(20),
              child: Image.asset(
                "assets/images/logo.png",
                fit: BoxFit.contain,
                // Error-handling: provides a fallback if image is missing
                errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.water_drop, size: 100, color: Colors.white),
              ),
            ),

            const SizedBox(height: 60),

            // EDITORIAL TYPOGRAPHY
            Text(
              "AQUAOPS",
              style: GoogleFonts.tenorSans(
                fontSize: 50,
                letterSpacing: 14,
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
            ),

            const SizedBox(height: 15),

            // DIVIDER LINE
            Container(
              width: 100,
              height: 1,
              color: Colors.white.withValues(alpha: 0.3),
            ),

            const SizedBox(height: 15),

            // SUBTITLE
            Text(
              "FLUID INTELLIGENCE",
              style: GoogleFonts.tenorSans(
                fontSize: 12,
                letterSpacing: 8,
                color: const Color(0xFF777777),
              ),
            ),
          ],
        ),
      ),
    );
  }
}