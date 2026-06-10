import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'profile_screen.dart';

class WaterAwarenessScreen extends StatefulWidget {
  const WaterAwarenessScreen({super.key});

  @override
  State<WaterAwarenessScreen> createState() => _WaterAwarenessScreenState();
}

class _WaterAwarenessScreenState extends State<WaterAwarenessScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _tipController = TextEditingController();

  // Elite Pro Palette
  static const Color aquaBlue = Color(0xFF22D3EE);
  static const Color emeraldGreen = Color(0xFF10B981);
  static const Color deepPurple = Color(0xFF6366F1);
  static const Color canvasBg = Color(0xFF020509);
  static const Color cardBg = Color(0xFF0B1015);
  static const Color accentCyan = Color(0xFF06B6D4);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _tipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: canvasBg,
      body: Stack(
        children: [
          // Dynamic Cinematic Background
          Positioned(top: -150, right: -100, child: _buildGlow(deepPurple.withValues(alpha: 0.15), 550)),
          Positioned(bottom: -100, left: -150, child: _buildGlow(aquaBlue.withValues(alpha: 0.12), 650)),
          Positioned(top: 300, left: 100, child: _buildGlow(emeraldGreen.withValues(alpha: 0.08), 450)),
          
          // Subtle Tech Grid
          _buildDecorativeGrid(),

          SafeArea(
            child: Column(
              children: [
                _buildPremiumHeader(),
                _buildModernTabBar(),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      _buildAwarenessFeed(),
                      _buildGreenChallenges(),
                      _buildLeaderboard(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _tabController.index == 0 
          ? _buildAnimatedFAB()
          : null,
      extendBody: true,
    );
  }

  Widget _buildDecorativeGrid() {
    return IgnorePointer(
      child: Opacity(
        opacity: 0.03,
        child: CustomPaint(
          size: Size.infinite,
          painter: GridPainter(),
        ),
      ),
    );
  }

  Widget _buildGlow(Color color, double size) {
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle, 
        boxShadow: [
          BoxShadow(
            color: color, 
            blurRadius: 150, 
            spreadRadius: 50,
            blurStyle: BlurStyle.normal,
          )
        ]
      ),
    );
  }

  Widget _buildPremiumHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 10)
                ],
              ),
              child: const Icon(Icons.keyboard_backspace_rounded, color: Colors.white, size: 20),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Colors.white, aquaBlue, Colors.white70],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds),
                  child: Text(
                    "HYDRO NEXUS", 
                    style: GoogleFonts.syne(
                      color: Colors.white, 
                      fontSize: 24, 
                      fontWeight: FontWeight.w900, 
                      letterSpacing: 2,
                    )
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Container(
                      width: 6, height: 6,
                      decoration: const BoxDecoration(color: emeraldGreen, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "LIVE COMMUNITY SYNC", 
                      style: GoogleFonts.montserrat(
                        color: Colors.white24, 
                        fontSize: 9, 
                        fontWeight: FontWeight.w900, 
                        letterSpacing: 2,
                      )
                    ),
                  ],
                ),
              ],
            ),
          ),
          _buildHeaderStats(),
        ],
      ),
    );
  }

  Widget _buildHeaderStats() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: aquaBlue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: aquaBlue.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Text("8.4k", style: GoogleFonts.poppins(color: aquaBlue, fontSize: 12, fontWeight: FontWeight.w800)),
          Text("ACTIVE", style: GoogleFonts.montserrat(color: aquaBlue.withValues(alpha: 0.5), fontSize: 7, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }

  Widget _buildModernTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: aquaBlue.withValues(alpha: 0.3)),
          boxShadow: [
            BoxShadow(color: aquaBlue.withValues(alpha: 0.1), blurRadius: 15, spreadRadius: -2)
          ],
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: aquaBlue,
        unselectedLabelColor: Colors.white24,
        labelStyle: GoogleFonts.syne(fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 1.2),
        unselectedLabelStyle: GoogleFonts.syne(fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 1.2),
        tabs: const [
          Tab(text: "TRANSMISSIONS"),
          Tab(text: "MISSIONS"),
          Tab(text: "HIERARCHY"),
        ],
      ),
    );
  }

  Widget _buildAnimatedFAB() {
    return FadeInUp(
      duration: const Duration(milliseconds: 800),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(color: aquaBlue.withValues(alpha: 0.3), blurRadius: 25, offset: const Offset(0, 10))
          ],
        ),
        child: FloatingActionButton.extended(
          backgroundColor: aquaBlue,
          onPressed: _showPostTipDialog,
          elevation: 0,
          highlightElevation: 0,
          icon: const Icon(Icons.add_circle_outline_rounded, color: Colors.black, size: 24),
          label: Text("INITIATE TRANSMISSION", style: GoogleFonts.syne(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 0.5)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
      ),
    );
  }

  Widget _buildAwarenessFeed() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('awareness_feed').orderBy('timestamp', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator(color: aquaBlue, strokeWidth: 2));
        final docs = snapshot.data!.docs;
        if (docs.isEmpty) return _buildEmptyFeedState();
        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(24, 10, 24, 100),
          itemCount: docs.length,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            final doc = docs[index];
            final data = doc.data() as Map<String, dynamic>;
            data['id'] = doc.id;
            return FadeInUp(
              delay: Duration(milliseconds: index * 100),
              child: _buildPremiumFeedCard(data),
            );
          },
        );
      },
    );
  }

  Widget _buildPremiumFeedCard(Map<String, dynamic> data) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: LinearGradient(
          colors: [Colors.white.withValues(alpha: 0.08), Colors.transparent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildAuthorAvatar(data['author']),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data['author'], 
                            style: GoogleFonts.syne(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800),
                          ),
                          Text(
                            "CORE CONTRIBUTOR • ACTIVE", 
                            style: GoogleFonts.montserrat(color: aquaBlue.withValues(alpha: 0.5), fontSize: 8, fontWeight: FontWeight.w900, letterSpacing: 1),
                          ),
                        ],
                      ),
                    ),
                    _buildPostMenu(data),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  data['content'], 
                  style: GoogleFonts.montserrat(
                    color: Colors.white.withValues(alpha: 0.85), 
                    fontSize: 15, 
                    height: 1.7, 
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.2,
                  )
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    Flexible(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildFeedAction(Icons.favorite_rounded, data['likes'].toString(), accentCyan),
                          const SizedBox(width: 12),
                          _buildFeedAction(Icons.chat_bubble_outline_rounded, "12", Colors.white24),
                          const SizedBox(width: 12),
                          GestureDetector(
                            onTap: () => _showShareOptions(data['content']),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.05),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.share_rounded, color: Colors.white24, size: 18),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    _buildTag(data['tag'].toString().toUpperCase()),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAuthorAvatar(String name) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(colors: [aquaBlue, deepPurple]),
      ),
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: const BoxDecoration(color: cardBg, shape: BoxShape.circle),
        child: CircleAvatar(
          radius: 18,
          backgroundColor: aquaBlue.withValues(alpha: 0.1),
          child: Text(name[0], style: const TextStyle(color: aquaBlue, fontSize: 14, fontWeight: FontWeight.w900)),
        ),
      ),
    );
  }

  Widget _buildPostMenu(Map<String, dynamic> data) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert_rounded, color: Colors.white24, size: 20),
      color: const Color(0xFF161B22),
      elevation: 20,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), 
        side: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
      ),
      onSelected: (value) {
        if (value == 'edit') {
          _showPostTipDialog(docId: data['id'], initialContent: data['content']);
        } else if (value == 'delete') {
          _confirmDeleteFeedItem(data['id']);
        }
      },
      itemBuilder: (context) => [
        _buildPopupItem('edit', Icons.edit_note_rounded, "MOD_PROTO", Colors.white70),
        _buildPopupItem('delete', Icons.delete_outline_rounded, "TERMINATE", Colors.redAccent),
      ],
    );
  }

  Widget _buildTag(String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      constraints: const BoxConstraints(maxWidth: 100),
      decoration: BoxDecoration(
        color: aquaBlue.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: aquaBlue.withValues(alpha: 0.15)),
      ),
      child: Text(
        tag, 
        style: GoogleFonts.syne(color: aquaBlue, fontSize: 8, fontWeight: FontWeight.w900, letterSpacing: 1),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }

  PopupMenuItem<String> _buildPopupItem(String value, IconData icon, String label, Color color) {
    return PopupMenuItem(
      value: value,
      height: 40,
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 14),
          Text(label, style: GoogleFonts.syne(color: color, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1)),
        ],
      ),
    );
  }

  Widget _buildFeedAction(IconData icon, String count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 8),
          Text(count, style: GoogleFonts.poppins(color: Colors.white38, fontSize: 12, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _buildGreenChallenges() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 10, 24, 100),
      physics: const BouncingScrollPhysics(),
      children: [
        _buildSectionTitle("PRIORITY MISSIONS"),
        const SizedBox(height: 20),
        _buildPremiumChallengeCard("HYDRO-SAVER X", "Reduce daily consumption by 15L.", "420 OPS ACTIVE", emeraldGreen, Icons.water_drop_rounded),
        _buildPremiumChallengeCard("NODE INSPECTION", "Detect and report 3 system leaks.", "128 OPS ACTIVE", aquaBlue, Icons.radar_rounded),
        _buildPremiumChallengeCard("PLASTIC PURGE", "Zero polymer usage for 7 cycles.", "856 OPS ACTIVE", deepPurple, Icons.eco_rounded),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Text(title, style: GoogleFonts.syne(color: Colors.white.withValues(alpha: 0.2), fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 3)),
        const SizedBox(width: 20),
        Expanded(child: Container(height: 1, decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.white.withValues(alpha: 0.1), Colors.transparent])))),
      ],
    );
  }

  Widget _buildPremiumChallengeCard(String title, String desc, String participants, Color color, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(35),
        border: Border.all(color: color.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: 0.05), blurRadius: 30, spreadRadius: -10)
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(35),
        child: Stack(
          children: [
            Positioned(right: -20, top: -20, child: Icon(icon, size: 120, color: color.withValues(alpha: 0.03))),
            Padding(
              padding: const EdgeInsets.all(28),
              child: Row(
                children: [
                  Container(
                    width: 60, height: 60,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1), 
                      shape: BoxShape.circle,
                      border: Border.all(color: color.withValues(alpha: 0.2)),
                    ),
                    child: Icon(icon, color: color, size: 28),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: GoogleFonts.syne(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                        const SizedBox(height: 6),
                        Text(desc, style: GoogleFonts.montserrat(color: Colors.white38, fontSize: 11, height: 1.5, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                          child: Text(participants, style: GoogleFonts.syne(color: color, fontSize: 8, fontWeight: FontWeight.w900, letterSpacing: 1)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15),
                  _buildJoinButton(color, title),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJoinButton(Color color, String title) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color, 
        foregroundColor: Colors.black,
        elevation: 10,
        shadowColor: color.withValues(alpha: 0.4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)), 
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
      ),
      onPressed: () => _handleJoinChallenge(title),
      child: Text("SYNC", style: GoogleFonts.syne(fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 1)),
    );
  }

  Widget _buildLeaderboard() {
    final List<Map<String, dynamic>> rankings = [
      {"dept": "Environmental Eng.", "score": "98.4", "rank": "1", "status": "ELITE"},
      {"dept": "Computer Science", "score": "92.1", "rank": "2", "status": "ALPHA"},
      {"dept": "Civil Engineering", "score": "88.7", "rank": "3", "status": "STABLE"},
      {"dept": "Business School", "score": "85.2", "rank": "4", "status": "SYNCING"},
      {"dept": "Medical Sciences", "score": "82.5", "rank": "5", "status": "LOW-OP"},
    ];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
          child: _buildSectionLabel("GLOBAL HIERARCHY", "REAL-TIME SUSTAINABILITY INDEX"),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(24, 10, 24, 40),
            itemCount: rankings.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final item = rankings[index];
              bool isTop = index == 0;
              return FadeInLeft(
                delay: Duration(milliseconds: index * 100),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: isTop ? aquaBlue.withValues(alpha: 0.04) : cardBg,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: isTop ? aquaBlue.withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.05)),
                  ),
                  child: Row(
                    children: [
                      _buildRankBadge(item['rank'], isTop),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item['dept'], style: GoogleFonts.syne(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800)),
                            const SizedBox(height: 4),
                            Text("STATUS: ${item['status']}", style: GoogleFonts.montserrat(color: isTop ? aquaBlue : Colors.white24, fontSize: 8, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
                          ],
                        ),
                      ),
                      _buildScoreDisplay(item['score']),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRankBadge(String rank, bool isTop) {
    return Container(
      width: 44, height: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isTop ? aquaBlue : Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(15),
        boxShadow: isTop ? [BoxShadow(color: aquaBlue.withValues(alpha: 0.3), blurRadius: 15, spreadRadius: -5)] : null,
      ),
      child: Text(
        "#$rank", 
        style: GoogleFonts.syne(color: isTop ? Colors.black : aquaBlue, fontSize: 16, fontWeight: FontWeight.w900)
      ),
    );
  }

  Widget _buildScoreDisplay(String score) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(score, style: GoogleFonts.poppins(color: emeraldGreen, fontSize: 20, fontWeight: FontWeight.w800)),
        Text("INDEX PT", style: GoogleFonts.montserrat(color: Colors.white24, fontSize: 8, fontWeight: FontWeight.w900, letterSpacing: 1)),
      ],
    );
  }

  Widget _buildSectionLabel(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(width: 4, height: 20, decoration: BoxDecoration(color: aquaBlue, borderRadius: BorderRadius.circular(2))),
            const SizedBox(width: 12),
            Text(title, style: GoogleFonts.syne(color: Colors.white, fontSize: 16, letterSpacing: 3, fontWeight: FontWeight.w900)),
          ],
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Text(subtitle, style: GoogleFonts.montserrat(color: aquaBlue.withValues(alpha: 0.4), fontSize: 8, fontWeight: FontWeight.w900, letterSpacing: 2)),
        ),
      ],
    );
  }

  Widget _buildEmptyFeedState() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            ZoomIn(
              duration: const Duration(seconds: 1),
              child: Container(
                width: 160, height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: aquaBlue.withValues(alpha: 0.1), width: 1),
                ),
                child: Center(
                  child: Container(
                    width: 140, height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: const DecorationImage(
                        image: NetworkImage("https://i.pinimg.com/736x/da/67/89/da6789cb6d98752e50747e7f2bbff9fa.jpg"),
                        fit: BoxFit.cover,
                      ),
                      boxShadow: [
                        BoxShadow(color: aquaBlue.withValues(alpha: 0.1), blurRadius: 40, spreadRadius: 10)
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50),
            FadeInUp(
              duration: const Duration(milliseconds: 800),
              child: Text(
                "SILENT SECTOR",
                style: GoogleFonts.syne(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: 5),
              ),
            ),
            const SizedBox(height: 16),
            FadeInUp(
              duration: const Duration(milliseconds: 1000),
              child: Text(
                "The neural network is waiting for data.\nInitialize the first transmission to sync.",
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(color: Colors.white24, fontSize: 13, height: 1.8, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 60),
            Pulse(
              infinite: true,
              child: ElevatedButton.icon(
                onPressed: _showPostTipDialog,
                icon: const Icon(Icons.bolt_rounded, color: Colors.black, size: 20),
                label: Text("START TRANSMISSION", style: GoogleFonts.syne(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: aquaBlue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 24),
                  elevation: 20,
                  shadowColor: aquaBlue.withValues(alpha: 0.3),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPostTipDialog({String? docId, String? initialContent}) {
    if (initialContent != null) {
      _tipController.text = initialContent;
    } else {
      _tipController.clear();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(45)),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          boxShadow: [const BoxShadow(color: Colors.black, blurRadius: 100)],
        ),
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 30, right: 30, top: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(10))),
            const SizedBox(height: 40),
            Text(docId == null ? "NEW TRANSMISSION" : "UPDATE PROTOCOL", style: GoogleFonts.syne(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: 4)),
            const SizedBox(height: 35),
            TextField(
              controller: _tipController,
              style: GoogleFonts.montserrat(color: Colors.white, fontSize: 16),
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Enter protocol data for community sync...",
                hintStyle: GoogleFonts.montserrat(color: Colors.white12, fontSize: 14),
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.02),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide(color: aquaBlue.withValues(alpha: 0.2))),
                contentPadding: const EdgeInsets.all(25),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: aquaBlue, 
                minimumSize: const Size(double.infinity, 65), 
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                elevation: 15,
                shadowColor: aquaBlue.withValues(alpha: 0.3),
              ),
              onPressed: () async {
                if (_tipController.text.isNotEmpty) {
                  if (docId == null) {
                    await FirebaseFirestore.instance.collection('awareness_feed').add({
                      'author': 'Luna Evergarden', 
                      'content': _tipController.text,
                      'likes': 0,
                      'tag': 'Global Sync',
                      'timestamp': FieldValue.serverTimestamp(),
                    });
                  } else {
                    await FirebaseFirestore.instance.collection('awareness_feed').doc(docId).update({
                      'content': _tipController.text,
                    });
                  }
                  _tipController.clear();
                  if (context.mounted) Navigator.pop(context);
                }
              },
              child: Text(docId == null ? "PUSH DATA" : "SYNC DATA", style: GoogleFonts.syne(color: Colors.black, fontWeight: FontWeight.w900, letterSpacing: 2, fontSize: 14)),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  void _confirmDeleteFeedItem(String docId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35), side: BorderSide(color: Colors.redAccent.withValues(alpha: 0.1))),
        title: Text("TERMINATE PROTOCOL?", style: GoogleFonts.syne(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 1)),
        content: Text("This action will permanently purge the transmission from the central node.", style: GoogleFonts.montserrat(color: Colors.white38, fontSize: 12, height: 1.6)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("ABORT", style: GoogleFonts.syne(color: Colors.white24, fontWeight: FontWeight.w800, letterSpacing: 1))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
            onPressed: () async {
              await FirebaseFirestore.instance.collection('awareness_feed').doc(docId).delete();
              if (context.mounted) Navigator.pop(context);
            },
            child: Text("PURGE", style: GoogleFonts.syne(color: Colors.white, fontWeight: FontWeight.w900, letterSpacing: 1)),
          ),
        ],
      ),
    );
  }

  void _showShareOptions(String content) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(45)),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(10))),
              const SizedBox(height: 30),
              Text(
                "BROADCAST DATA", 
                textAlign: TextAlign.center,
                style: GoogleFonts.syne(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 3)
              ),
              const SizedBox(height: 40),
              Wrap(
                spacing: 20,
                runSpacing: 25,
                alignment: WrapAlignment.center,
                children: [
                  _buildShareItem(FontAwesomeIcons.whatsapp, "WHATSAPP", Colors.green, () => _launchURL("https://wa.me/?text=${Uri.encodeComponent(content)}")),
                  _buildShareItem(Icons.message_rounded, "MESSAGE", Colors.blue, () => _launchURL("sms:?body=${Uri.encodeComponent(content)}")),
                  _buildShareItem(FontAwesomeIcons.twitter, "X / TWIT", Colors.white, () => _launchURL("https://twitter.com/intent/tweet?text=${Uri.encodeComponent(content)}")),
                  _buildShareItem(FontAwesomeIcons.youtube, "YOUTUBE", Colors.red, () => _launchURL("https://www.youtube.com/results?search_query=${Uri.encodeComponent(content)}")),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShareItem(dynamic icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.05), 
              shape: BoxShape.circle,
              border: Border.all(color: color.withValues(alpha: 0.1)),
            ),
            child: (icon is IconData) 
              ? Icon(icon, color: color, size: 26)
              : FaIcon(icon, color: color, size: 26),
          ),
          const SizedBox(height: 14),
          Text(label, style: GoogleFonts.montserrat(color: Colors.white24, fontSize: 8, fontWeight: FontWeight.w900, letterSpacing: 1)),
        ],
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      Fluttertoast.showToast(msg: "Interface Error: Could not launch $url");
    }
  }

  Future<void> _handleJoinChallenge(String title) async {
    Fluttertoast.showToast(
      msg: "Mission Synced: $title",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: emeraldGreen,
      textColor: Colors.black,
    );

    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList('activity_history') ?? [];
    history.insert(0, "Mission $title|${DateTime.now().toIso8601String()}");
    await prefs.setStringList('activity_history', history);

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40), side: BorderSide(color: emeraldGreen.withValues(alpha: 0.1))),
        title: Center(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(color: emeraldGreen.withValues(alpha: 0.05), shape: BoxShape.circle),
                child: const Icon(Icons.verified_rounded, color: emeraldGreen, size: 40),
              ),
              const SizedBox(height: 20),
              Text("SYNC SUCCESSFUL", style: GoogleFonts.syne(color: emeraldGreen, fontWeight: FontWeight.w900, fontSize: 20, letterSpacing: 2)),
            ],
          ),
        ),
        content: Text(
          "Your operative profile is now synchronized with '$title'. Real-time conservation metrics are being calculated.",
          textAlign: TextAlign.center,
          style: GoogleFonts.montserrat(color: Colors.white54, fontSize: 13, height: 1.8),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: emeraldGreen, 
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
                },
                child: Text("OPERATIVE PROFILE", style: GoogleFonts.syne(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 1)),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.5)
      ..strokeWidth = 0.5;

    for (double i = 0; i < size.width; i += 40) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += 40) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
