import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:animate_do/animate_do.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'login_page.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _image;

  // Profile Data State
  String _name = "Luna Evergarden";
  String _role = "Senior Environmental Specialist";
  String _bio = "Dedicated to building sustainable campus infrastructure and optimizing water resource management through AI-driven insights.";
  String _username = "@luna_aqua";
  String _email = "luna.eco@aquaops.com";
  String _phone = "+1 234 567 890";
  String _gender = "Female";
  String _dob = "12 March 1998";
  String _location = "Silicon Valley, CA";
  String _studentId = "AQ-2026-9901";
  String _department = "Environmental Engineering";

  // Settings State
  bool _notifications = true;
  bool _privacyMode = false;
  bool _darkTheme = true;

  List<Map<String, dynamic>> _activityHistory = [];

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString('profile_name') ?? _name;
      _role = prefs.getString('profile_role') ?? _role;
      _bio = prefs.getString('profile_bio') ?? _bio;
      _username = prefs.getString('profile_username') ?? _username;
      _email = prefs.getString('profile_email') ?? _email;
      _phone = prefs.getString('profile_phone') ?? _phone;
      _gender = prefs.getString('profile_gender') ?? _gender;
      _dob = prefs.getString('profile_dob') ?? _dob;
      _location = prefs.getString('profile_location') ?? _location;
      _studentId = prefs.getString('profile_student_id') ?? _studentId;
      _department = prefs.getString('profile_department') ?? _department;
      _notifications = prefs.getBool('settings_notifications') ?? _notifications;
      _privacyMode = prefs.getBool('settings_privacy') ?? _privacyMode;
      _darkTheme = prefs.getBool('settings_dark_theme') ?? _darkTheme;
      
      final imagePath = prefs.getString('profile_image_path');
      if (imagePath != null) {
        _image = File(imagePath);
      }

      // Load activity history
      final historyStrings = prefs.getStringList('activity_history') ?? [];
      _activityHistory = historyStrings.map((item) {
        final parts = item.split('|');
        final title = parts[0];
        final dateStr = parts.length > 1 ? parts[1] : DateTime.now().toIso8601String();
        final date = DateTime.parse(dateStr);
        final formattedDate = DateFormat('dd MMM yyyy').format(date);
        
        return {
          'title': title,
          'date': formattedDate,
          'icon': title.contains('Joined') ? Icons.eco : Icons.history,
          'status': 'Active'
        };
      }).toList();
      
      // If empty, add default history items
      if (_activityHistory.isEmpty) {
        _activityHistory = [
          {'title': 'Water Leak Reported', 'date': '22 Oct 2024', 'icon': Icons.report_problem, 'status': 'Resolved'},
          {'title': 'Eco-Quiz Completed', 'date': '15 Oct 2024', 'icon': Icons.quiz, 'status': 'Earned 50 pts'},
          {'title': 'Sensor Maintenance', 'date': '10 Oct 2024', 'icon': Icons.settings, 'status': 'Completed'},
        ];
      }
    });
  }

  Future<void> _saveProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_name', _name);
    await prefs.setString('profile_role', _role);
    await prefs.setString('profile_bio', _bio);
    await prefs.setString('profile_username', _username);
    await prefs.setString('profile_email', _email);
    await prefs.setString('profile_phone', _phone);
    await prefs.setString('profile_gender', _gender);
    await prefs.setString('profile_dob', _dob);
    await prefs.setString('profile_location', _location);
    await prefs.setString('profile_student_id', _studentId);
    await prefs.setString('profile_department', _department);
  }

  Future<void> _saveSetting(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  // Design Palette (Matching Sustainability Dashboard)
  static const Color emeraldGreen = Color(0xFF10B981);
  static const Color aquaBlue = Color(0xFF0EA5E9);
  static const Color deepPurple = Color(0xFF6366F1);
  static const Color cardBg = Color(0xFF0B1015);
  static const Color canvasBg = Color(0xFF020509);

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_image_path', pickedFile.path);
    }
  }

  void _showEditBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 20),
              Text("EDIT PROFILE", style: GoogleFonts.syne(color: Colors.white, fontWeight: FontWeight.w900, letterSpacing: 2)),
              const SizedBox(height: 20),
              _buildEditField("Full Name", _name, (v) => _name = v),
              _buildEditField("Role", _role, (v) => _role = v),
              _buildEditField("Bio", _bio, (v) => _bio = v, maxLines: 3),
              _buildEditField("Username", _username, (v) => _username = v),
              _buildEditField("Email", _email, (v) => _email = v),
              _buildEditField("Phone", _phone, (v) => _phone = v),
              _buildEditField("Gender", _gender, (v) => _gender = v),
              _buildEditField("Date of Birth", _dob, (v) => _dob = v),
              _buildEditField("Location", _location, (v) => _location = v),
              _buildEditField("Student ID", _studentId, (v) => _studentId = v),
              _buildEditField("Department", _department, (v) => _department = v),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: aquaBlue,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                onPressed: () {
                  setState(() {});
                  _saveProfileData();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Profile Updated")));
                },
                child: Text("SAVE CHANGES", style: GoogleFonts.syne(color: Colors.black, fontWeight: FontWeight.w900, letterSpacing: 2)),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditField(String label, String initialValue, Function(String) onChanged, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: GoogleFonts.montserrat(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
          const SizedBox(height: 8),
          TextFormField(
            initialValue: initialValue,
            maxLines: maxLines,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white.withOpacity(0.05),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: aquaBlue, width: 1)),
            ),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Future<void> _handleLogout() async {
    final prefs = await SharedPreferences.getInstance();
    // We might want to keep some settings but clear "logged in" state if we had one
    // For now, let's just go back to login screen
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: canvasBg,
      body: Stack(
        children: [
          // Background Glows
          Positioned(top: -100, right: -50, child: _buildGlow(aquaBlue.withValues(alpha: 0.1), 300)),
          Positioned(bottom: 100, left: -100, child: _buildGlow(deepPurple.withValues(alpha: 0.05), 400)),

          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildAppBar(),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildProfileHeader(),
                    const SizedBox(height: 30),
                    _buildSustainabilityStats(),
                    const SizedBox(height: 30),
                    _buildSectionTitle("PERSONAL INFORMATION"),
                    _buildInfoCard([
                      _buildInfoTile(Icons.person_outline, "Username", _username),
                      _buildInfoTile(Icons.email_outlined, "Email", _email),
                      _buildInfoTile(Icons.phone_outlined, "Phone", _phone),
                      _buildInfoTile(Icons.wc_outlined, "Gender", _gender),
                      _buildInfoTile(Icons.calendar_today_outlined, "Date of Birth", _dob),
                      _buildInfoTile(Icons.location_on_outlined, "Location", _location),
                    ]),
                    const SizedBox(height: 30),
                    _buildSectionTitle("ORGANIZATION DETAILS"),
                    _buildInfoCard([
                      _buildInfoTile(Icons.badge_outlined, "Student ID", _studentId),
                      _buildInfoTile(Icons.account_balance_outlined, "Department", _department),
                      _buildInfoTile(Icons.admin_panel_settings_outlined, "Account Type", "Verified Contributor"),
                      _buildInfoTile(Icons.verified_user_outlined, "Membership", "Platinum Tier"),
                    ]),
                    const SizedBox(height: 30),
                    _buildSectionTitle("SUSTAINABILITY TRACKER"),
                    _buildInfoCard([
                      _buildInfoTile(Icons.report_gmailerrorred_rounded, "Reports Submitted", "42"),
                      _buildInfoTile(Icons.task_alt_rounded, "Issues Resolved", "38"),
                      _buildInfoTile(Icons.stars_rounded, "Reward Points", "2,450"),
                      _buildInfoTile(Icons.eco_rounded, "Eco Score", "94/100"),
                      _buildInfoTile(Icons.leaderboard_rounded, "Leaderboard Rank", "#5"),
                    ]),
                    const SizedBox(height: 30),
                    _buildSectionTitle("ACHIEVEMENTS"),
                    _buildBadgeSection(),
                    const SizedBox(height: 30),
                    _buildSectionTitle("ACTIVITY & SAVED"),
                    _buildInfoCard([
                      _buildActionTile(Icons.history_rounded, "Activity History", onTap: () => _showHistoryBottomSheet("Activity History", _activityHistory)),
                      _buildActionTile(Icons.bookmark_outline_rounded, "Saved Items / Favorites", onTap: () => _showHistoryBottomSheet("Saved Items", [
                        {'title': 'Smart Irrigation Guide', 'date': 'Saved on 12 Oct', 'icon': Icons.article, 'status': 'PDF'},
                        {'title': 'East Wing Map', 'date': 'Saved on 05 Oct', 'icon': Icons.map, 'status': 'Offline'},
                      ])),
                      _buildActionTile(Icons.image_outlined, "Submitted Images History", onTap: () => _showHistoryBottomSheet("Images History", [
                        {'title': 'Leak_Detection_01.jpg', 'date': '22 Oct 2024', 'icon': Icons.image, 'status': 'Verified'},
                        {'title': 'Plant_Growth_East.jpg', 'date': '18 Oct 2024', 'icon': Icons.image, 'status': 'Archived'},
                      ])),
                      _buildActionTile(Icons.assignment_turned_in_outlined, "Complaint History", onTap: () => _showHistoryBottomSheet("Complaint History", [
                        {'title': 'Faulty Water Meter', 'date': '20 Oct 2024', 'icon': Icons.assignment, 'status': 'In Progress'},
                        {'title': 'Low Water Pressure', 'date': '12 Oct 2024', 'icon': Icons.assignment, 'status': 'Fixed'},
                      ])),
                    ]),
                    const SizedBox(height: 30),
                    _buildSectionTitle("SETTINGS & PREFERENCES"),
                    _buildInfoCard([
                      _buildSettingsTile(Icons.notifications_none_rounded, "Notifications", _notifications, (v) {
                        setState(() => _notifications = v);
                        _saveSetting('settings_notifications', v);
                      }),
                      _buildSettingsTile(Icons.lock_outline_rounded, "Privacy Mode", _privacyMode, (v) {
                        setState(() => _privacyMode = v);
                        _saveSetting('settings_privacy', v);
                      }),
                      _buildActionTile(Icons.security_rounded, "Security Settings", onTap: () => _showSimpleDialog("Security", "Your account is protected with 256-bit encryption. Multi-factor authentication is active for all critical infrastructure access.")),
                      _buildActionTile(Icons.password_rounded, "Change Password", onTap: _showChangePasswordDialog),
                      _buildActionTile(Icons.language_rounded, "Language", trailing: "English (US)", onTap: () => _showSimpleDialog("Language", "Currently, only English (US) is supported for this region. Additional language packs will be available in the next system update.")),
                      _buildSettingsTile(Icons.dark_mode_outlined, "Dark Theme", _darkTheme, (v) {
                        setState(() => _darkTheme = v);
                        _saveSetting('settings_dark_theme', v);
                      }),
                    ]),
                    const SizedBox(height: 30),
                    _buildSectionTitle("SUPPORT"),
                    _buildInfoCard([
                      _buildActionTile(Icons.help_outline_rounded, "Help & Support", onTap: () => _showSimpleDialog("Help & Support", "For technical issues with water sensors or dashboard analytics, contact our 24/7 operations command center at support@aquaops.com or call ext. 9901.")),
                      _buildActionTile(Icons.description_outlined, "Terms & Conditions", onTap: () => _showSimpleDialog("Terms & Conditions", "By using AquaOps, you agree to the responsible reporting of campus infrastructure issues. Unauthorized access to sensor neural networks is strictly prohibited.")),
                      _buildActionTile(Icons.privacy_tip_outlined, "Privacy Policy", onTap: () => _showSimpleDialog("Privacy Policy", "We collect sensor data and report history to optimize campus sustainability. Your personal identity is encrypted and never shared with third-party vendors.")),
                    ]),
                    const SizedBox(height: 40),
                    _buildLogoutButton(),
                    const SizedBox(height: 60),
                  ]),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGlow(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: color, blurRadius: 100, spreadRadius: 50)],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.edit_rounded, color: aquaBlue),
          onPressed: _showEditBottomSheet,
        ),
      ],
      pinned: true,
      centerTitle: true,
      title: Text(
        "PROFILE",
        style: GoogleFonts.syne(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 4),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return FadeInDown(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: aquaBlue.withValues(alpha: 0.5), width: 3),
                  boxShadow: [BoxShadow(color: aquaBlue.withValues(alpha: 0.2), blurRadius: 20)],
                ),
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: cardBg,
                  backgroundImage: _image != null 
                      ? FileImage(_image!) 
                      : const NetworkImage("https://api.dicebear.com/7.x/notionists/png?seed=Luna") as ImageProvider,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(color: aquaBlue, shape: BoxShape.circle),
                    child: const Icon(Icons.camera_alt_rounded, color: Colors.black, size: 20),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            _name,
            style: GoogleFonts.syne(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Text(
            _role,
            style: GoogleFonts.montserrat(fontSize: 12, color: aquaBlue, fontWeight: FontWeight.w600, letterSpacing: 1),
          ),
          const SizedBox(height: 8),
          Text(
            "Joined: January 2024",
            style: GoogleFonts.montserrat(fontSize: 10, color: Colors.white24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              _bio,
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(fontSize: 12, color: Colors.white54, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSustainabilityStats() {
    return FadeInUp(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem("CO2 Saved", "1.2 Ton", emeraldGreen),
                _buildStatItem("Water Saved", "45k L", aquaBlue),
                _buildStatItem("Impact", "High", deepPurple),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildSmallStat("Posts", "124")),
              const SizedBox(width: 12),
              Expanded(child: _buildSmallStat("Followers", "8.2k")),
              const SizedBox(width: 12),
              Expanded(child: _buildSmallStat("Following", "450")),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSmallStat(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.02)),
      ),
      child: Column(
        children: [
          Text(value, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
          Text(label, style: GoogleFonts.montserrat(fontSize: 9, color: Colors.white24, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 4),
        Text(label, style: GoogleFonts.montserrat(fontSize: 10, color: Colors.white24, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, bottom: 12),
      child: Text(
        title,
        style: GoogleFonts.syne(fontSize: 11, fontWeight: FontWeight.w900, color: Colors.white38, letterSpacing: 2),
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.03)),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Icon(icon, color: aquaBlue.withValues(alpha: 0.5), size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: GoogleFonts.montserrat(fontSize: 9, color: Colors.white24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(value, style: GoogleFonts.montserrat(fontSize: 13, color: Colors.white70, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(IconData icon, String title, bool value, Function(bool) onChanged) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Icon(icon, color: Colors.white24, size: 22),
      title: Text(title, style: GoogleFonts.montserrat(fontSize: 14, color: Colors.white70)),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: aquaBlue,
        activeTrackColor: aquaBlue.withValues(alpha: 0.2),
      ),
    );
  }

  Widget _buildActionTile(IconData icon, String title, {String? trailing, VoidCallback? onTap}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Icon(icon, color: Colors.white24, size: 22),
      title: Text(title, style: GoogleFonts.montserrat(fontSize: 14, color: Colors.white70)),
      trailing: trailing != null 
          ? Text(trailing, style: GoogleFonts.montserrat(fontSize: 12, color: aquaBlue))
          : const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white10, size: 14),
      onTap: onTap ?? () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$title is not implemented yet")));
      },
    );
  }

  void _showHistoryBottomSheet(String title, List<Map<String, dynamic>> items) {
    showModalBottomSheet(
      context: context,
      backgroundColor: cardBg,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 20),
            Text(title.toUpperCase(), style: GoogleFonts.syne(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 2)),
            const SizedBox(height: 20),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) => ListTile(
                  leading: CircleAvatar(backgroundColor: aquaBlue.withValues(alpha: 0.1), child: Icon(items[index]['icon'] as IconData, color: aquaBlue, size: 18)),
                  title: Text(items[index]['title'] as String, style: GoogleFonts.montserrat(color: Colors.white70, fontSize: 14)),
                  subtitle: Text(items[index]['date'] as String, style: GoogleFonts.montserrat(color: Colors.white24, fontSize: 11)),
                  trailing: Text(items[index]['status'] as String, style: GoogleFonts.montserrat(color: emeraldGreen, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        title: Text("CHANGE PASSWORD", style: GoogleFonts.syne(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildEditField("Current Password", "", (v) {}, maxLines: 1),
            _buildEditField("New Password", "", (v) {}, maxLines: 1),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("CANCEL")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: aquaBlue),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Password Updated Successfully")));
            },
            child: const Text("UPDATE", style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  void _showSimpleDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        title: Text(title.toUpperCase(), style: GoogleFonts.syne(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(child: Text(content, style: GoogleFonts.montserrat(color: Colors.white70, fontSize: 13, height: 1.5))),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("CLOSE"))],
      ),
    );
  }

  Widget _buildBadgeSection() {
    return Container(
      height: 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        children: [
          _buildBadge("Eco Warrior", Icons.verified_rounded, emeraldGreen),
          _buildBadge("Water Saver", Icons.water_drop_rounded, aquaBlue),
          _buildBadge("Top Reporter", Icons.auto_awesome_rounded, deepPurple),
          _buildBadge("Fast Resolver", Icons.bolt_rounded, const Color(0xFFFBBF24)),
        ],
      ),
    );
  }

  Widget _buildBadge(String name, IconData icon, Color color) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border: Border.all(color: color.withValues(alpha: 0.2)),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(fontSize: 9, color: Colors.white38, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return FadeInUp(
      child: InkWell(
        onTap: _handleLogout,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: Colors.redAccent.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.redAccent.withValues(alpha: 0.2)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.logout_rounded, color: Colors.redAccent, size: 20),
              const SizedBox(width: 12),
              Text(
                "TERMINATE SESSION",
                style: GoogleFonts.syne(color: Colors.redAccent, fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
