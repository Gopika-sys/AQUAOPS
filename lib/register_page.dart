import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();

  String _selectedGender = "Female";
  bool _hidePass = true;

  bool _validatePasswordStructure(String value) {
    return RegExp(r'[A-Z]').hasMatch(value) &&
        RegExp(r'[a-z]').hasMatch(value) &&
        RegExp(r'[0-9]').hasMatch(value) &&
        RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value);
  }

  void _executeLocalRegistration() async {
    if (!_formKey.currentState!.validate()) return;

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('local_username', _userController.text.trim());
    await prefs.setString('local_password', _passController.text);
    await prefs.setString('local_gender', _selectedGender);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Membership Profile Registered Successfully."),
        backgroundColor: Color(0xFF6B2D5C), // Matches Login theme
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0A0B),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFFD4AF37)),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Create Maison Membership",
                  style: TextStyle(fontFamily: 'Serif', fontSize: 28, fontWeight: FontWeight.w300, color: Colors.white, letterSpacing: 1),
                ),
                const SizedBox(height: 40),

                TextFormField(
                  controller: _userController,
                  style: const TextStyle(color: Colors.white),
                  cursorColor: const Color(0xFFD4AF37),
                  decoration: _buildLuxuryInputDecoration("Desired Username Identity", Icons.portrait_outlined),
                  validator: (v) => (v == null || v.trim().length < 8) ? "Minimum 8 characters required" : null,
                ),
                const SizedBox(height: 24),

                DropdownButtonFormField<String>(
                  initialValue: _selectedGender,
                  dropdownColor: const Color(0xFF161213),
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: _buildLuxuryInputDecoration("Gender Identity Recognition", Icons.transgender),
                  items: ["Female", "Male", "Non-Binary", "Prefer Not to Say"]
                      .map((l) => DropdownMenuItem(value: l, child: Text(l, style: const TextStyle(letterSpacing: 1))))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedGender = v!),
                ),
                const SizedBox(height: 24),

                TextFormField(
                  controller: _passController,
                  obscureText: _hidePass,
                  style: const TextStyle(color: Colors.white),
                  cursorColor: const Color(0xFFD4AF37),
                  decoration: _buildLuxuryInputDecoration("Secure Vault Password", Icons.vpn_key_outlined).copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(_hidePass ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: Colors.white38, size: 20),
                      onPressed: () => setState(() => _hidePass = !_hidePass),
                    ),
                  ),
                  validator: (v) => (v == null || !_validatePasswordStructure(v)) ? "Must meet complexity standards" : null,
                ),
                const SizedBox(height: 24),

                TextFormField(
                  controller: _confirmPassController,
                  obscureText: _hidePass,
                  style: const TextStyle(color: Colors.white),
                  cursorColor: const Color(0xFFD4AF37),
                  decoration: _buildLuxuryInputDecoration("Verify Passphrase Configuration", Icons.lock_reset_outlined),
                  validator: (v) => (v != _passController.text) ? "Password configuration mismatch" : null,
                ),

                const SizedBox(height: 48),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD4AF37),
                    minimumSize: const Size(double.infinity, 54),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  ),
                  onPressed: _executeLocalRegistration,
                  child: const Text(
                    "CREATE MEMBERSHIP RECORD",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black, letterSpacing: 2),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Consistent Luxury Decorator
  InputDecoration _buildLuxuryInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white38, fontSize: 12, letterSpacing: 1),
      prefixIcon: Icon(icon, color: const Color(0xFFD4AF37), size: 18),
      contentPadding: const EdgeInsets.symmetric(vertical: 16),
      enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white12)),
      focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFD4AF37), width: 1.2)),
    );
  }
}