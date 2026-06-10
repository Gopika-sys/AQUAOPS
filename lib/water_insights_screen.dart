import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:animate_do/animate_do.dart';
import 'ticketing_screen.dart';
import 'campus_water_infra_screen.dart';
import 'sustainability_dashboard_screen.dart';
import 'ai_advisor_screen.dart';

class WaterInsightsScreen extends StatelessWidget {
  const WaterInsightsScreen({super.key});

  // Premium Palette
  static const Color aquaBlue = Color(0xFF22D3EE);
  static const Color deepPurple = Color(0xFF6366F1);
  static const Color emeraldGreen = Color(0xFF10B981);
  static const Color canvasBg = Color(0xFF020509);
  static const Color glassWhite = Colors.white10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: canvasBg,
      body: Stack(
        children: [
          // Dynamic Background Elements
          Positioned(top: -100, right: -50, child: _buildGlow(deepPurple.withValues(alpha: 0.15), 400)),
          Positioned(bottom: 200, left: -150, child: _buildGlow(aquaBlue.withValues(alpha: 0.1), 500)),
          
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildAdvancedAppBar(context),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(height: 30),
                    FadeInDown(child: _buildSectionTitle("NEURAL SYSTEM STATUS")),
                    FadeInUp(child: _buildLiveSystemSnapshot()),
                    const SizedBox(height: 40),
                    FadeInDown(child: _buildSectionTitle("WATER AVAILABILITY ANALYTICS")),
                    FadeInUp(child: _buildWaterAvailabilityCard()),
                    const SizedBox(height: 40),
                    FadeInDown(child: _buildSectionTitle("CONSERVATION PERFORMANCE")),
                    FadeInUp(child: _buildPerformanceCard()),
                    const SizedBox(height: 40),
                    FadeInDown(child: _buildSectionTitle("SECTOR INTELLIGENCE")),
                    FadeInUp(child: _buildCampusBlocksGrid()),
                    const SizedBox(height: 40),
                    FadeInDown(child: _buildSectionTitle("CRITICAL ACTIONS")),
                    FadeInUp(child: _buildQuickActionsGrid(context)),
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
        boxShadow: [BoxShadow(color: color, blurRadius: 150, spreadRadius: 50)],
      ),
    );
  }

  Widget _buildAdvancedAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 220,
      pinned: true,
      stretch: true,
      backgroundColor: canvasBg,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: false,
        titlePadding: const EdgeInsets.only(left: 20, bottom: 20),
        title: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    "HYDROMETRIC",
                    style: GoogleFonts.syne(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 4),
                  ),
                ),
                Text(
                  "INSIGHTS & ANALYTICS",
                  style: GoogleFonts.montserrat(fontSize: 8, fontWeight: FontWeight.w800, color: aquaBlue, letterSpacing: 2),
                ),
              ],
            );
          }
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              "https://images.unsplash.com/photo-1451187580459-43490279c0fa?auto=format&fit=crop&q=80&w=1200",
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.3),
                    canvasBg.withValues(alpha: 0.7),
                    canvasBg,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Container(width: 4, height: 16, decoration: BoxDecoration(color: aquaBlue, borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.syne(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 3),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveSystemSnapshot() {
    return _glassContainer(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Stack(
            children: [
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: NetworkImage("https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&q=80&w=1000"),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(Colors.black26, BlendMode.darken),
                    ),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black.withValues(alpha: 0.7)],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: emeraldGreen.withValues(alpha: 0.2), 
                        borderRadius: BorderRadius.circular(5), 
                        border: Border.all(color: emeraldGreen.withValues(alpha: 0.5))
                      ),
                      child: Row(
                        children: [
                          Container(width: 6, height: 6, decoration: const BoxDecoration(color: emeraldGreen, shape: BoxShape.circle)),
                          const SizedBox(width: 8),
                          Text("SYSTEM ACTIVE", style: GoogleFonts.montserrat(color: emeraldGreen, fontSize: 8, fontWeight: FontWeight.w900, letterSpacing: 1)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Last Scan: 2 mins ago", 
                        style: GoogleFonts.montserrat(color: Colors.white38, fontSize: 9, fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSimpleMetric("INFRA HEALTH", "98.4%", aquaBlue),
                _buildSimpleMetric("SENSORS", "1,242", deepPurple),
                _buildSimpleMetric("ERR RATE", "0.02%", Colors.redAccent),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildWaterAvailabilityCard() {
    return _glassContainer(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: _buildAvailItem("MAIN RESERVOIR", "85%", Icons.waves_rounded, Colors.blueAccent)),
              const SizedBox(width: 12),
              Expanded(child: _buildAvailItem("NET VOLUME", "420k L", Icons.opacity_rounded, Colors.tealAccent)),
            ],
          ),
          const SizedBox(height: 30),
          SizedBox(
            height: 100,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: const [FlSpot(0, 3), FlSpot(2, 4.5), FlSpot(4, 3.8), FlSpot(6, 6), FlSpot(8, 4.2), FlSpot(10, 5.5)],
                    isCurved: true,
                    color: aquaBlue,
                    barWidth: 4,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [aquaBlue.withValues(alpha: 0.2), Colors.transparent],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(color: Colors.white10, height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: _buildAvailItem("DAILY FLUX", "12.4k L", Icons.speed_rounded, Colors.orangeAccent)),
              const SizedBox(width: 12),
              Expanded(child: _buildAvailItem("STATUS", "OPTIMAL", Icons.verified_user_rounded, emeraldGreen)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceCard() {
    return _glassContainer(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 80,
                width: 80,
                child: CircularProgressIndicator(
                  value: 0.74,
                  strokeWidth: 10,
                  backgroundColor: Colors.white.withValues(alpha: 0.03),
                  valueColor: const AlwaysStoppedAnimation<Color>(emeraldGreen),
                  strokeCap: StrokeCap.round,
                ),
              ),
              Text("74", style: GoogleFonts.poppins(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
            ],
          ),
          const SizedBox(width: 25),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("SUSTAINABILITY INDEX", style: GoogleFonts.syne(color: Colors.white38, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 2)),
                const SizedBox(height: 4),
                Text("EXCELLENT", style: GoogleFonts.poppins(color: emeraldGreen, fontSize: 18, fontWeight: FontWeight.w900)),
                const SizedBox(height: 8),
                Text("Water conservation is trending 12.4% higher than average.", style: GoogleFonts.montserrat(color: Colors.white54, fontSize: 10, height: 1.4)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCampusBlocksGrid() {
    return SizedBox(
      height: 200,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        children: [
        _buildDetailedBlockCard("HOSTEL COMPLEX", "HIGH DEMAND", "https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?auto=format&fit=crop&q=80&w=400", Colors.blue),
        _buildDetailedBlockCard("ACADEMIC WING", "OPTIMIZED", "https://images.unsplash.com/photo-1497366216548-37526070297c?auto=format&fit=crop&q=80&w=400", Colors.teal),
        _buildDetailedBlockCard("CENTRAL CAFE", "NOMINAL", "https://images.unsplash.com/photo-1554118811-1e0d58224f24?auto=format&fit=crop&q=80&w=400", Colors.orange),
        _buildDetailedBlockCard("SPORTS ARENA", "LOW USAGE", "https://images.unsplash.com/photo-1534438327276-14e5300c3a48?auto=format&fit=crop&q=80&w=400", Colors.purple),
        ],
      ),
    );
  }

  Widget _buildDetailedBlockCard(String title, String status, String imgUrl, Color accent) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 20),
      child: _glassContainer(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                child: Image.network(imgUrl, fit: BoxFit.cover, width: double.infinity),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(title, style: GoogleFonts.syne(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800)),
                    ),
                    const SizedBox(height: 4),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(status, style: GoogleFonts.montserrat(color: accent, fontSize: 8, fontWeight: FontWeight.w900, letterSpacing: 1)),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionsGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 2.2, // Increased for more horizontal space
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: [
        _buildActionTile(context, "REPORT LEAK", Icons.bug_report_rounded, Colors.redAccent, const TicketingScreen()),
        _buildActionTile(context, "INFRA MAP", Icons.account_tree_rounded, aquaBlue, const CampusWaterInfraScreen()),
        _buildActionTile(context, "AI ADVISOR", Icons.psychology_rounded, Colors.amberAccent, const AIAdvisorScreen()),
        _buildActionTile(context, "CORE DATA", Icons.analytics_rounded, deepPurple, const SustainabilityDashboardScreen()),
      ],
    );
  }

  Widget _buildActionTile(BuildContext context, String label, IconData icon, Color color, Widget? target) {
    return GestureDetector(
      onTap: () {
        if (target != null) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => target));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$label integration pending neural link.")));
        }
      },
      child: _glassContainer(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  label, 
                  style: GoogleFonts.syne(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 1),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSimpleMetric(String label, String val, Color color) {
    return Expanded(
      child: Column(
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              val, 
              style: GoogleFonts.poppins(color: color, fontSize: 15, fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label, 
              style: GoogleFonts.montserrat(color: Colors.white24, fontSize: 7, fontWeight: FontWeight.w900, letterSpacing: 1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailItem(String label, String val, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label, 
                  style: GoogleFonts.montserrat(color: Colors.white38, fontSize: 8, fontWeight: FontWeight.w900, letterSpacing: 0.5),
                ),
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  val, 
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _glassContainer({required Widget child, EdgeInsetsGeometry? padding}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: padding ?? const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: 0.08),
                  Colors.white.withValues(alpha: 0.02),
                ],
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
