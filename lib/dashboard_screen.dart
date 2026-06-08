import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'sensor_repository.dart';
import 'dashboard_provider.dart';
import 'digital_twin_screen.dart';
import 'digital_twin_provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = SensorRepository();

    return Scaffold(
      backgroundColor: const Color(0xFF020509),
      extendBody: true,
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF22D3EE),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const DigitalTwinScreen()),
        ),
        child: const Icon(Icons.analytics_rounded, color: Colors.black),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: repo.getCollectionStream(context.watch<DigitalTwinProvider>().activeCollection),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final sensorMap = { for (var doc in snapshot.data!.docs) doc.id : doc.data() as Map<String, dynamic> };
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.read<DigitalTwinProvider>().updateAllSensors(sensorMap);
            });
          }

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                _buildHeader(),
                Transform.translate(
                  offset: const Offset(0, -60),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        // Now correctly listening to the simulated DashboardProvider
                        FadeInUp(
                          child: Consumer<DashboardProvider>(
                            builder: (context, data, _) => _buildHeroCard(data),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildStatusRow(),
                        const SizedBox(height: 20),
                        _buildIncidentRow(),
                        const SizedBox(height: 20),
                        Consumer<DashboardProvider>(
                          builder: (context, data, _) => _buildDualStats(data),
                        ),
                        const SizedBox(height: 20),
                        _buildActivityFeed(),
                        const SizedBox(height: 120),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: _buildLuxuryBottomNav(),
    );
  }

  Widget _buildHeader() => Stack(
    children: [
      Container(
        height: 350,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage("https://i.pinimg.com/1200x/0b/b2/97/0bb2971d30174700ee37ab2b09a60806.jpg"),
            fit: BoxFit.cover,
          ),
        ),
      ),
      Container(
        height: 350,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black.withValues(alpha: 0.2), Colors.transparent, const Color(0xFF020509)],
          ),
        ),
      ),
      Positioned(
        top: 70, left: 25,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("AQUAOPS", style: GoogleFonts.syne(fontSize: 14, letterSpacing: 6, color: const Color(0xFF22D3EE))),
            Text("OPERATIONS\nCOMMAND", style: GoogleFonts.playfairDisplay(fontSize: 40, fontWeight: FontWeight.w900, color: Colors.white, height: 1.1)),
          ],
        ),
      ),
    ],
  );

  Widget _buildHeroCard(DashboardProvider data) => _glassContainer(
    padding: const EdgeInsets.all(25),
    child: Row(children: [
      const Icon(Icons.speed_rounded, color: Color(0xFF22D3EE), size: 40),
      const SizedBox(width: 20),
      Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("CAMPUS WATER HEALTH", style: GoogleFonts.montserrat(color: Colors.white54, fontSize: 10, letterSpacing: 3)),
          Text("${data.healthScore.toStringAsFixed(1)} / 10.0", style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
        ]),
      )
    ]),
  );

  Widget _buildStatusRow() => Consumer<DigitalTwinProvider>(
    builder: (context, digitalTwin, _) => _glassContainer(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(children: [
        Icon(Icons.shield_rounded, color: digitalTwin.isGlobalAlarm ? Colors.redAccent : Colors.tealAccent, size: 20),
        const SizedBox(width: 15),
        Text(digitalTwin.isGlobalAlarm ? "CRITICAL SYSTEM ALARM" : "ALL SYSTEMS ONLINE", style: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white70)),
        const Spacer(),
        Container(width: 8, height: 8, decoration: BoxDecoration(color: digitalTwin.isGlobalAlarm ? Colors.redAccent : Colors.tealAccent, shape: BoxShape.circle))
      ]),
    ),
  );

  Widget _buildIncidentRow() => Row(
    children: [
      Expanded(child: _glassContainer(child: const ListTile(contentPadding: EdgeInsets.symmetric(horizontal: 10), leading: Icon(Icons.notifications_active, color: Colors.redAccent), title: Text("Active", style: TextStyle(color: Colors.white, fontSize: 12))))),
      const SizedBox(width: 15),
      Expanded(child: _glassContainer(child: const ListTile(contentPadding: EdgeInsets.symmetric(horizontal: 10), leading: Icon(Icons.info_outline, color: Colors.amberAccent), title: Text("Ongoing", style: TextStyle(color: Colors.white, fontSize: 12))))),
    ],
  );

  Widget _buildDualStats(DashboardProvider data) => Row(children: [
    Expanded(child: _glassContainer(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const FaIcon(FontAwesomeIcons.droplet, color: Colors.blue), const SizedBox(height: 10), Text("${data.consumption}L", style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold))]))),
    const SizedBox(width: 15),
    Expanded(child: _glassContainer(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Icon(Icons.water_damage_rounded, color: Colors.blue), const SizedBox(height: 10), Text("140kL", style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold))]))),
  ]);

  Widget _buildActivityFeed() => _glassContainer(padding: const EdgeInsets.all(20), child: Column(children: List.generate(3, (index) => Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Row(children: [Container(width: 6, height: 6, decoration: const BoxDecoration(color: Colors.blue, shape: BoxShape.circle)), const SizedBox(width: 10), Text("System Update ${index + 1}", style: const TextStyle(color: Colors.white70))])))));

  Widget _glassContainer({required Widget child, EdgeInsetsGeometry? padding}) => ClipRRect(
    borderRadius: BorderRadius.circular(25),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Container(
        padding: padding ?? const EdgeInsets.all(15),
        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.05), border: Border.all(color: Colors.white.withValues(alpha: 0.1))),
        child: child,
      ),
    ),
  );

  Widget _buildLuxuryBottomNav() => Container(
    margin: const EdgeInsets.fromLTRB(30, 0, 30, 30),
    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
    decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.7), borderRadius: BorderRadius.circular(40), border: Border.all(color: Colors.white.withValues(alpha: 0.1))),
    child: const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Icon(Icons.dashboard_rounded, color: Color(0xFF22D3EE)),
      Icon(Icons.map_outlined, color: Colors.white30),
      Icon(Icons.insights_rounded, color: Colors.white30),
      Icon(Icons.person_outline_rounded, color: Colors.white30),
    ]),
  );
}