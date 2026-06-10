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

  bool _isPassVisible = false;
  bool _isConfirmVisible = false;

  void _executeLocalRegistration() async {
    if (!_formKey.currentState!.validate()) return;
    if (_passController.text != _confirmPassController.text) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Passphrases do not match.")));
      return;
    }
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('local_username', _userController.text.trim());
    await prefs.setString('local_password', _passController.text);
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020617),
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, iconTheme: const IconThemeData(color: Color(0xFF22D3EE))),
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(center: Alignment.bottomCenter, radius: 1.0, colors: [Color(0xFF083344), Color(0xFF020617)]),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Initialize AquaOpss", style: TextStyle(fontFamily: 'Serif', fontSize: 32, fontWeight: FontWeight.w200, color: Colors.white, letterSpacing: 1)),
                  const SizedBox(height: 60),
                  _buildAquaField(_userController, "Desired Identity", Icons.badge_outlined, false, false, () {}),
                  const SizedBox(height: 24),
                  _buildAquaField(_passController, "System Password", Icons.lock_outline, true, _isPassVisible, () => setState(() => _isPassVisible = !_isPassVisible)),
                  const SizedBox(height: 24),
                  _buildAquaField(_confirmPassController, "Verify Password", Icons.lock_reset_outlined, true, _isConfirmVisible, () => setState(() => _isConfirmVisible = !_isConfirmVisible)),
                  const SizedBox(height: 60),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF22D3EE),
                        minimumSize: const Size(double.infinity, 60),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))
                    ),
                    onPressed: _executeLocalRegistration,
                    child: const Text("INITIALIZE ACCOUNT", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF020617), letterSpacing: 3)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAquaField(TextEditingController controller, String label, IconData icon, bool isPass, bool visible, VoidCallback toggle) => TextFormField(
    controller: controller,
    obscureText: isPass && !visible,
    style: const TextStyle(color: Colors.white),
    decoration: InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white54, fontSize: 12, letterSpacing: 2),
      prefixIcon: Icon(icon, color: const Color(0xFF22D3EE), size: 20),
      suffixIcon: isPass ? IconButton(
        icon: Icon(visible ? Icons.visibility : Icons.visibility_off, color: Colors.white30, size: 18),
        onPressed: toggle,
      ) : null,
      enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white12)),
      focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF22D3EE))),
    ),
    validator: (v) => (v == null || v.isEmpty) ? "Required" : null,
  );
}