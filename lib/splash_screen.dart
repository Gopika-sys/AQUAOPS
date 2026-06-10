import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'network_service.dart';
import 'login_page.dart';
import 'main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Added a local state to track if we are waiting for connection
  bool _isWaitingForConnection = false;

  @override
  void initState() {
    super.initState();
    _handleNavigation();
  }

  void _handleNavigation() async {
    await Future.delayed(const Duration(seconds: 3));

    bool connected = await NetworkService.isConnected();

    if (connected) {
      _navigateToLogin();
    } else {
      if (mounted) {
        setState(() => _isWaitingForConnection = true);
      }
      isConnectedNotifier.addListener(_onConnectionChanged);
    }
  }

  void _onConnectionChanged() {
    if (isConnectedNotifier.value) {
      isConnectedNotifier.removeListener(_onConnectionChanged);
      _navigateToLogin();
    }
  }

  void _navigateToLogin() {
    if (mounted) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen())
      );
    }
  }

  @override
  void dispose() {
    isConnectedNotifier.removeListener(_onConnectionChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020202),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // --- KEEPING EXISTING LOGO UI ---
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
                errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.water_drop, size: 100, color: Colors.white),
              ),
            ),
            const SizedBox(height: 60),
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
            Container(width: 100, height: 1, color: Colors.white.withValues(alpha: 0.3)),
            const SizedBox(height: 15),
            Text(
              "FLUID INTELLIGENCE",
              style: GoogleFonts.tenorSans(
                fontSize: 12,
                letterSpacing: 8,
                color: const Color(0xFF777777),
              ),
            ),
            const SizedBox(height: 40),

            // --- ENHANCED DYNAMIC STATUS UI ---
            ValueListenableBuilder<bool>(
              valueListenable: isConnectedNotifier,
              builder: (context, isConnected, child) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: !isConnected
                      ? Column(
                    key: const ValueKey('offline'),
                    children: [
                      const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white24),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "CONNECTION LOST. RETRYING...",
                        style: GoogleFonts.tenorSans(
                          fontSize: 10,
                          letterSpacing: 3,
                          color: Colors.orangeAccent.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  )
                      : const CircularProgressIndicator(
                    key: ValueKey('online'),
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white24),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}