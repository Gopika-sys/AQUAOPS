import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'register_page.dart';

class MainStorefrontScreen extends StatelessWidget {
  final String username;
  const MainStorefrontScreen({super.key, required this.username});
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: const Color(0xFF020617),
        body: Center(
            child: Text("Welcome, $username",
                style: const TextStyle(color: Colors.white, fontSize: 24))),
      );
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  void _processLoginAuthentication() async {
    if (!_formKey.currentState!.validate()) return;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final storedUser = prefs.getString('local_username') ?? "";
    final storedPass = prefs.getString('local_password') ?? "";

    if (_usernameController.text.trim() == storedUser && _passwordController.text == storedPass) {
      if (!mounted) return;
      Navigator.pushReplacement(context, PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => MainStorefrontScreen(username: storedUser),
        transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
        transitionDuration: const Duration(milliseconds: 800),
      ));
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Authentication Denied."), backgroundColor: Color(0xFF0E7490)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020617),
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(center: Alignment.topRight, radius: 1.2, colors: [Color(0xFF083344), Color(0xFF020617)]),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text("A Q U A  O P S S", style: TextStyle(fontFamily: 'Serif', fontSize: 14, color: Color(0xFF22D3EE), letterSpacing: 10)),
                  const SizedBox(height: 60),
                  const Align(alignment: Alignment.centerLeft, child: Text("Sign In", style: TextStyle(fontFamily: 'Serif', fontSize: 42, color: Colors.white, letterSpacing: 1))),
                  const SizedBox(height: 60),
                  _buildAquaField(_usernameController, "Username", Icons.water_drop_outlined, false),
                  const SizedBox(height: 24),
                  _buildAquaField(_passwordController, "Password", Icons.lock_outline_rounded, true),
                  const SizedBox(height: 60),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.05),
                      side: const BorderSide(color: Color(0xFF22D3EE), width: 1),
                      minimumSize: const Size(double.infinity, 60),
                    ),
                    onPressed: _processLoginAuthentication,
                    child: const Text("AUTHENTICATE SYSTEM", style: TextStyle(letterSpacing: 3, fontSize: 12, color: Colors.white)),
                  ),
                  TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterScreen())), child: const Text("Create New Membership", style: TextStyle(color: Colors.white38, fontSize: 11, letterSpacing: 2))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAquaField(TextEditingController controller, String label, IconData icon, bool isPass) => TextFormField(
    controller: controller,
    obscureText: isPass && !_isPasswordVisible,
    style: const TextStyle(color: Colors.white),
    decoration: InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white54, fontSize: 12, letterSpacing: 2),
      prefixIcon: Icon(icon, color: const Color(0xFF22D3EE), size: 20),
      suffixIcon: isPass ? IconButton(
        icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off, color: Colors.white30, size: 18),
        onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
      ) : null,
      enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white12)),
      focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF22D3EE))),
    ),
    validator: (v) => (v == null || v.isEmpty) ? "Required" : null,
  );
}