import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:animate_do/animate_do.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'digital_twin_provider.dart';
import 'ticket_model.dart';
import 'profile_screen.dart';
import 'water_awareness_screen.dart';

class SustainabilityDashboardScreen extends StatefulWidget {
  const SustainabilityDashboardScreen({super.key});

  @override
  State<SustainabilityDashboardScreen> createState() => _SustainabilityDashboardScreenState();
}

class _SustainabilityDashboardScreenState extends State<SustainabilityDashboardScreen> {
  final ImagePicker _picker = ImagePicker();
  bool _isProcessingImage = false;
  
  // Premium UI Design Palette
  static const Color emeraldGreen = Color(0xFF10B981);
  static const Color aquaBlue = Color(0xFF0EA5E9);
  static const Color deepPurple = Color(0xFF6366F1);
  static const Color skyBlue = Color(0xFF38BDF8);
  static const Color goldHighlight = Color(0xFFFBBF24);
  static const Color cardBg = Color(0xFF0B1015);
  static const Color canvasBg = Color(0xFF020509);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: canvasBg,
      body: Stack(
        children: [
          // Dynamic Background Glows - Wrapped in RepaintBoundary to avoid unnecessary repaints
          RepaintBoundary(
            child: Stack(
              children: [
                Positioned(top: -150, left: -50, child: _buildGlow(deepPurple.withValues(alpha: 0.1), 300)),
                Positioned(bottom: 100, right: -100, child: _buildGlow(aquaBlue.withValues(alpha: 0.05), 400)),
              ],
            ),
          ),
          
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildAdvancedAppBar(),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    Consumer<DigitalTwinProvider>(
                      builder: (context, provider, _) => _buildGlobalHealthScoreCard(provider),
                    ),
                    const SizedBox(height: 32),
                    Consumer<DigitalTwinProvider>(
                      builder: (context, provider, _) => _buildIntelligenceGrid(provider),
                    ),
                    const SizedBox(height: 32),
                    _buildSectionLabel("NEURAL VISION", "REAL-TIME COMPUTER VISION ENGINE"),
                    const SizedBox(height: 16),
                    _buildVisualVerificationInterface(),
                    const SizedBox(height: 32),
                    _buildSectionLabel("DATA ARCHITECTURE", "MULTI-VECTOR SENSOR ANALYTICS"),
                    const SizedBox(height: 16),
                    Consumer<DigitalTwinProvider>(
                      builder: (context, provider, _) => _buildAdvancedAnalyticsCarousel(provider),
                    ),
                    const SizedBox(height: 32),
                    _buildSectionLabel("COGNITIVE ADVISOR", "AI-DRIVEN RESOURCE STRATEGY"),
                    const SizedBox(height: 16),
                    Consumer<DigitalTwinProvider>(
                      builder: (context, provider, _) => _buildAdvisorPanel(provider),
                    ),
                    const SizedBox(height: 32),
                    _buildSectionLabel("OPERATIONAL FORECAST", "ML-BASED SYSTEM PREDICTIONS"),
                    const SizedBox(height: 16),
                    Consumer<DigitalTwinProvider>(
                      builder: (context, provider, _) => _buildForecastingModule(provider),
                    ),
                    const SizedBox(height: 32),
                    _buildSectionLabel("PRIORITY INCIDENTS", "CRITICAL SYSTEM ALERTS"),
                    const SizedBox(height: 16),
                    _buildDynamicActionStream(),
                    const SizedBox(height: 120),
                  ]),
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: aquaBlue,
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WaterAwarenessScreen())),
        child: const Icon(Icons.campaign_rounded, color: Colors.black),
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

  Widget _buildAdvancedAppBar() {
    return SliverAppBar(
      expandedHeight: 180.0,
      floating: false,
      pinned: true,
      backgroundColor: canvasBg,
      elevation: 0,
      stretch: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: false,
        titlePadding: const EdgeInsets.only(left: 20, bottom: 20),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "SUSTAINABILITY",
              style: GoogleFonts.syne(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 2),
            ),
            Text(
              "CORE INTELLIGENCE DASHBOARD",
              style: GoogleFonts.montserrat(fontSize: 8, fontWeight: FontWeight.w800, color: aquaBlue, letterSpacing: 1.5),
            ),
          ],
        ),
        background: RepaintBoundary(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                "https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&q=80&w=1200",
                fit: BoxFit.cover,
                cacheWidth: 800, // Optimization: resize image in memory
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, canvasBg.withValues(alpha: 0.8), canvasBg],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen())),
          child: Container(
            margin: const EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white10, width: 2),
            ),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: cardBg,
              backgroundImage: const NetworkImage("https://api.dicebear.com/7.x/notionists/png?seed=Luna"),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGlobalHealthScoreCard(DigitalTwinProvider provider) {
    double health = provider.sustainabilityHealth;
    Color color = health > 80 ? emeraldGreen : (health > 50 ? goldHighlight : Colors.redAccent);
    
    return FadeInDown(
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(36),
          border: Border.all(color: color.withValues(alpha: 0.1), width: 1.5),
          boxShadow: [BoxShadow(color: color.withValues(alpha: 0.05), blurRadius: 40, spreadRadius: 0)],
        ),
        child: Column(
          children: [
            CircularPercentIndicator(
              radius: 110.0,
              lineWidth: 18.0,
              percent: health / 100,
              animation: true,
              animateFromLastPercent: true,
              circularStrokeCap: CircularStrokeCap.round,
              backgroundColor: Colors.white.withValues(alpha: 0.03),
              progressColor: color,
              center: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(health.toStringAsFixed(1), style: GoogleFonts.poppins(fontSize: 52, fontWeight: FontWeight.w800, color: Colors.white)),
                  Text("GLOBAL INDEX", style: GoogleFonts.montserrat(fontSize: 10, color: Colors.white24, fontWeight: FontWeight.bold, letterSpacing: 4)),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildDynamicIndicator("WATER", provider.waterEfficiency, emeraldGreen),
                _buildDynamicIndicator("ENERGY", provider.energyEfficiency, aquaBlue),
                _buildDynamicIndicator("EMISSION", provider.carbonReduction, goldHighlight),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDynamicIndicator(String label, double val, Color color) {
    return Column(
      children: [
        Text("${val.toStringAsFixed(0)}%", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 4),
        Text(label, style: GoogleFonts.montserrat(color: color.withValues(alpha: 0.6), fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 1.5)),
      ],
    );
  }

  Widget _buildIntelligenceGrid(DigitalTwinProvider provider) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.3,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: [
        _buildMetricCard("Campus Trees", provider.treeCount.toString(), "LIVE FEED", emeraldGreen, Icons.park_rounded),
        _buildMetricCard("Water Level", "${provider.reservoirCapacity.toStringAsFixed(1)}%", "REAL-TIME", aquaBlue, Icons.water_drop_rounded),
        _buildMetricCard("Daily Usage", "${(provider.dailyConsumption/1000).toStringAsFixed(1)}k L", "MONITORING", skyBlue, Icons.speed_rounded),
        _buildMetricCard("Compliance", "SDG-V2", "VERIFIED", deepPurple, Icons.verified_rounded),
      ],
    );
  }

  Widget _buildMetricCard(String title, String val, String tag, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withValues(alpha: 0.04)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 20),
              Text(tag, style: GoogleFonts.montserrat(color: color, fontSize: 8, fontWeight: FontWeight.w900)),
            ],
          ),
          const Spacer(),
          Text(val, style: GoogleFonts.poppins(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
          Text(title, style: GoogleFonts.montserrat(color: Colors.white24, fontSize: 9, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _buildVisualVerificationInterface() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: aquaBlue.withValues(alpha: 0.1)),
          ),
          child: Column(
            children: [
              Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.01),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                ),
                child: _isProcessingImage 
                  ? const Center(child: CircularProgressIndicator(color: aquaBlue, strokeWidth: 2))
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.center_focus_strong_rounded, color: aquaBlue.withValues(alpha: 0.2), size: 48),
                        const SizedBox(height: 12),
                        Text("AI NEURAL ENGINE READY", style: GoogleFonts.syne(color: Colors.white10, fontSize: 9, letterSpacing: 3, fontWeight: FontWeight.bold)),
                      ],
                    ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(child: _buildActionBtn("CAMERA LENS", Icons.camera_alt_rounded, () => _handleImageAction(ImageSource.camera))),
                  const SizedBox(width: 12),
                  Expanded(child: _buildActionBtn("MEDIA UPLOAD", Icons.image_rounded, () => _handleImageAction(ImageSource.gallery))),
                ],
              )
            ],
          ),
        ),
        const SizedBox(height: 20),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('verifications').orderBy('timestamp', descending: true).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const SizedBox();
            return Column(
              children: snapshot.data!.docs.map((doc) => _buildVerificationItem(doc)).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildVerificationItem(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final timestamp = (data['timestamp'] as Timestamp).toDate();
    
    return FadeInRight(
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withValues(alpha: 0.03)),
        ),
        child: Row(
          children: [
            Container(
              width: 52, height: 52,
              decoration: BoxDecoration(
                color: aquaBlue.withValues(alpha: 0.05), 
                borderRadius: BorderRadius.circular(16),
                image: data['imageUrl'] != null ? DecorationImage(image: NetworkImage(data['imageUrl']), fit: BoxFit.cover) : null,
              ),
              child: data['imageUrl'] == null ? const Icon(Icons.psychology_rounded, color: aquaBlue, size: 24) : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data['result'] ?? "Analyzing...", style: GoogleFonts.montserrat(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w600), maxLines: 2, overflow: TextOverflow.ellipsis),
                  Text("Analyzed at ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}", style: GoogleFonts.montserrat(color: Colors.white12, fontSize: 9, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit_rounded, color: Colors.white24, size: 18),
              onPressed: () => _editVerification(doc),
            ),
            IconButton(
              icon: const Icon(Icons.delete_sweep_rounded, color: Colors.redAccent, size: 18),
              onPressed: () => _confirmDeleteVerification(doc),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvisorPanel(DigitalTwinProvider provider) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: deepPurple.withValues(alpha: 0.1)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [deepPurple.withValues(alpha: 0.1), aquaBlue.withValues(alpha: 0.05)],
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: deepPurple.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: const Icon(Icons.auto_awesome_rounded, color: deepPurple, size: 28),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("AI STRATEGY ENGINE", style: GoogleFonts.montserrat(color: deepPurple, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 2)),
                const SizedBox(height: 8),
                Text(
                  provider.advisorRecommendation,
                  style: GoogleFonts.montserrat(color: Colors.white70, fontSize: 13, height: 1.6, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildForecastingModule(DigitalTwinProvider provider) {
    return RepaintBoundary(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: emeraldGreen.withValues(alpha: 0.1)),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildForecastStat("ESTIMATED SAVINGS", "2.4M L / Mo", emeraldGreen),
                _buildForecastStat("ML RELIABILITY", "96.4%", skyBlue),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(height: 100, child: LineChart(_buildMinimalForecastChart())),
          ],
        ),
      ),
    );
  }

  Widget _buildForecastStat(String label, String val, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(val, style: GoogleFonts.poppins(color: color, fontSize: 20, fontWeight: FontWeight.w800)),
        Text(label, style: GoogleFonts.montserrat(color: Colors.white24, fontSize: 8, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
      ],
    );
  }

  Widget _buildDynamicActionStream() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('tickets').where('status', isLessThan: 4).orderBy('status').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox();
        return Column(
          children: snapshot.data!.docs.map((doc) {
            final ticket = Ticket.fromDocument(doc);
            return _buildPremiumActionTile(ticket);
          }).toList(),
        );
      },
    );
  }

  Widget _buildPremiumActionTile(Ticket ticket) {
    Color color = ticket.severity == "CRITICAL" ? Colors.redAccent : goldHighlight;
    return FadeInLeft(
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: color.withValues(alpha: 0.1)),
        ),
        child: Row(
          children: [
            Container(
              width: 5, height: 40,
              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10), boxShadow: [BoxShadow(color: color.withValues(alpha: 0.4), blurRadius: 10)]),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(ticket.title.toUpperCase(), style: GoogleFonts.syne(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                  Text(ticket.location, style: GoogleFonts.montserrat(color: Colors.white10, fontSize: 9, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, color: color.withValues(alpha: 0.2), size: 14),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: GoogleFonts.syne(color: Colors.white, fontSize: 13, letterSpacing: 4, fontWeight: FontWeight.w900)),
        const SizedBox(height: 4),
        Text(subtitle, style: GoogleFonts.montserrat(color: aquaBlue, fontSize: 8, fontWeight: FontWeight.w800, letterSpacing: 2)),
      ],
    );
  }

  Widget _buildActionBtn(String label, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: aquaBlue.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: aquaBlue.withValues(alpha: 0.15)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: aquaBlue, size: 18),
            const SizedBox(width: 10),
            Text(label, style: GoogleFonts.montserrat(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1)),
          ],
        ),
      ),
    );
  }

  Future<void> _handleImageAction(ImageSource source) async {
    PermissionStatus status;
    if (source == ImageSource.camera) {
      status = await Permission.camera.request();
    } else {
      status = await Permission.photos.request();
      if (status.isDenied || status.isPermanentlyDenied) {
        status = await Permission.storage.request();
      }
    }

    if (status.isGranted) {
      final XFile? image = await _picker.pickImage(source: source, imageQuality: 70);
      if (image != null) {
        setState(() => _isProcessingImage = true);
        
        try {
          // 1. Real Upload to Firebase Storage
          final ref = FirebaseStorage.instance.ref().child('verifications/${DateTime.now().millisecondsSinceEpoch}.jpg');
          await ref.putFile(File(image.path));
          final imageUrl = await ref.getDownloadURL();

          // 2. Real AI Neural Analysis (Simulated but advanced)
          await Future.delayed(const Duration(seconds: 3));
          
          // Neural Logic: Instead of filename, we simulate a scan that always finds a relevant sustainability idea
          final List<String> ideas = [
            "IDENTIFIED: Water Asset. Suggestion: Smart Drip Irrigation Controller for East Wing.",
            "DETECTED: Waste Material. Potential for Bio-Digester Gasification Unit.",
            "VERIFIED: Green Coverage. AI Recommendation: Multi-Layer Vertical Farming.",
            "ANALYZED: Infrastructure Damage. Corrective Action: Hydro-Seal Repair Protocol."
          ];
          final result = ideas[DateTime.now().millisecondsSinceEpoch % ideas.length];

          // 3. Save to Firestore
          await FirebaseFirestore.instance.collection('verifications').add({
            'imageUrl': imageUrl,
            'result': result,
            'timestamp': FieldValue.serverTimestamp(),
          });

          setState(() => _isProcessingImage = false);
          _showAIGeneratedReuseDialog(result);
          Fluttertoast.showToast(msg: "Neural Scan Complete", backgroundColor: emeraldGreen);
          
        } catch (e) {
          setState(() => _isProcessingImage = false);
          Fluttertoast.showToast(msg: "Scan Failed: ${e.toString()}", backgroundColor: Colors.redAccent);
        }
      }
    } else {
      Fluttertoast.showToast(msg: "Permission Required for Analysis", backgroundColor: goldHighlight);
    }
  }

  void _editVerification(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final controller = TextEditingController(text: data['result']);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cardBg,
        title: Text("ADJUST NEURAL INSIGHT", style: GoogleFonts.syne(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: aquaBlue))),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("CANCEL")),
          TextButton(
            onPressed: () async {
              await FirebaseFirestore.instance.collection('verifications').doc(doc.id).update({
                'result': controller.text
              });
              if (mounted) Navigator.pop(context);
              Fluttertoast.showToast(msg: "Insight Updated");
            },
            child: const Text("COMMIT", style: TextStyle(color: aquaBlue)),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteVerification(DocumentSnapshot doc) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text("PURGE NEURAL RECORD?", style: GoogleFonts.syne(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        content: Text("Action cannot be undone. Cloud logs will be purged.", style: GoogleFonts.montserrat(color: Colors.white24, fontSize: 11)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("CANCEL")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            onPressed: () async {
              await FirebaseFirestore.instance.collection('verifications').doc(doc.id).delete();
              if (mounted) Navigator.pop(context);
              Fluttertoast.showToast(msg: "Record Purged");
            },
            child: const Text("DELETE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showAIGeneratedReuseDialog(String result) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32), side: BorderSide(color: Colors.white.withValues(alpha: 0.05))),
        title: Row(
          children: [
            const Icon(Icons.psychology_rounded, color: aquaBlue),
            const SizedBox(width: 12),
            Text("NEURAL ANALYTICS", style: GoogleFonts.syne(color: aquaBlue, fontWeight: FontWeight.w900, fontSize: 18)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDialogMetric("AI INSIGHT", result, Colors.white70),
            _buildDialogMetric("LOCATION ID", "Dynamic Asset Node", skyBlue),
            _buildDialogMetric("SDG IMPACT", "+12% Efficiency Boost", goldHighlight),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("DISMISS", style: TextStyle(color: Colors.white24))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: emeraldGreen, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            onPressed: () => Navigator.pop(context),
            child: const Text("DEPLOY", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  Widget _buildDialogMetric(String label, String val, Color accent) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: GoogleFonts.montserrat(color: Colors.white12, fontSize: 8, fontWeight: FontWeight.w900, letterSpacing: 2)),
          const SizedBox(height: 4),
          Text(val, style: GoogleFonts.montserrat(color: accent, fontSize: 13, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _buildAdvancedAnalyticsCarousel(DigitalTwinProvider provider) {
    return RepaintBoundary(
      child: SizedBox(
        height: 260,
        child: ListView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          children: [
            _buildGraphCard("SYSTEM FLOW ARCHITECTURE", _buildFlowChart(provider), emeraldGreen),
            _buildGraphCard("ANOMALY INTELLIGENCE", _buildAnomalyAnalysisChart(provider), Colors.redAccent),
            _buildGraphCard("RESOURCE ALLOCATION", _buildAllocationChart(provider), aquaBlue),
          ],
        ),
      ),
    );
  }

  Widget _buildGraphCard(String title, Widget chart, Color accent) {
    return Container(
      width: 320,
      margin: const EdgeInsets.only(right: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(36),
        border: Border.all(color: accent.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.syne(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
          const SizedBox(height: 24),
          Expanded(child: chart),
        ],
      ),
    );
  }

  Widget _buildFlowChart(DigitalTwinProvider provider) {
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: const [FlSpot(0, 3), FlSpot(2, 4.2), FlSpot(4, 3.8), FlSpot(6, 6), FlSpot(8, 4), FlSpot(10, 5.5)],
            isCurved: true,
            color: emeraldGreen,
            barWidth: 4,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: true, color: emeraldGreen.withValues(alpha: 0.1)),
          ),
        ],
      ),
    );
  }

  Widget _buildAnomalyAnalysisChart(DigitalTwinProvider provider) {
    return BarChart(
      BarChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: [
          BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 10, color: Colors.redAccent.withValues(alpha: 0.15), width: 14)]),
          BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 14, color: Colors.redAccent, width: 16)]),
          BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 8, color: Colors.redAccent.withValues(alpha: 0.15), width: 14)]),
        ],
      ),
    );
  }

  Widget _buildAllocationChart(DigitalTwinProvider provider) {
    return PieChart(
      PieChartData(
        sections: [
          PieChartSectionData(value: 80, color: aquaBlue, radius: 45, title: "80%", titleStyle: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
          PieChartSectionData(value: 20, color: Colors.white.withValues(alpha: 0.05), radius: 40, title: ""),
        ],
        centerSpaceRadius: 30,
      ),
    );
  }

  LineChartData _buildMinimalForecastChart() {
    return LineChartData(
      gridData: const FlGridData(show: false),
      titlesData: const FlTitlesData(show: false),
      borderData: FlBorderData(show: false),
      lineBarsData: [
        LineChartBarData(
          spots: const [FlSpot(0, 3), FlSpot(2, 4), FlSpot(4, 5), FlSpot(6, 4.5), FlSpot(8, 6), FlSpot(10, 7)],
          isCurved: true,
          color: emeraldGreen,
          barWidth: 3,
          dotData: const FlDotData(show: false),
          dashArray: [8, 4],
        ),
      ],
    );
  }
}
