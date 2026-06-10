import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:google_fonts/google_fonts.dart';
import 'sustainability_dashboard_screen.dart';
import 'dashboard_screen.dart';
import 'ticketing_screen.dart';
import 'digital_twin_screen.dart';
import 'water_map_screen.dart';

class CampusWaterInfraScreen extends StatefulWidget {
  const CampusWaterInfraScreen({super.key});

  @override
  State<CampusWaterInfraScreen> createState() => _CampusWaterInfraScreenState();
}

class _CampusWaterInfraScreenState extends State<CampusWaterInfraScreen> {
  late GoogleMapController _mapController;
  
  static const LatLng _collegeCenter = LatLng(10.8256, 77.0620);

  // Map state
  MapType _currentMapType = MapType.hybrid;
  bool _showInfrastructure = true;
  bool _showAssets = true;
  bool _showMarkers = true;

  final Set<Polyline> _infrastructurePipelines = {
    Polyline(
      polylineId: const PolylineId('pipe_1'),
      points: [const LatLng(10.8260, 77.0625), const LatLng(10.8245, 77.0615)],
      color: Colors.blueAccent.withValues(alpha: 0.5),
      width: 3,
    ),
    Polyline(
      polylineId: const PolylineId('pipe_2'),
      points: [const LatLng(10.8260, 77.0625), const LatLng(10.8265, 77.0610)],
      color: Colors.blueAccent.withValues(alpha: 0.5),
      width: 3,
    ),
  };

  final Set<Marker> _markers = {
    Marker(
      markerId: const MarkerId('tank_main'),
      position: const LatLng(10.8260, 77.0625),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
    ),
    Marker(
      markerId: const MarkerId('hostel_b'),
      position: const LatLng(10.8245, 77.0615),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    ),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020509),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Campus Digital Water Map",
          style: GoogleFonts.syne(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const CircleAvatar(radius: 14, backgroundColor: Colors.white12, child: Icon(Icons.person, size: 16, color: Colors.white70)),
            onPressed: () {},
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Stack(
        children: [
          // 3. The Live Map View in a RepaintBoundary
          RepaintBoundary(
            child: GoogleMap(
              initialCameraPosition: const CameraPosition(target: _collegeCenter, zoom: 17.5),
              mapType: _currentMapType,
              myLocationEnabled: true,
              zoomControlsEnabled: false,
              markers: _showMarkers ? _markers : {},
              polylines: _showInfrastructure ? _infrastructurePipelines : {},
              onMapCreated: (controller) {
                _mapController = controller;
              },
            ),
          ),

          // 2. Interactive Map Layer Controls (Pills on Left)
          Positioned(
            top: 20,
            left: 15,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPillButton("Main Campus Map", Icons.map_outlined, true),
                const SizedBox(height: 10),
                _buildPillButton("Water Infrastructure", Icons.waves, _showInfrastructure, 
                  onTap: () => setState(() => _showInfrastructure = !_showInfrastructure)),
                const SizedBox(height: 10),
                _buildPillButton("Asset Overlays", Icons.layers_outlined, _showAssets,
                  onTap: () => setState(() => _showAssets = !_showAssets)),
              ],
            ),
          ),

          // Action Icons (Vertical FABs on Right)
          Positioned(
            top: 20,
            right: 15,
            child: Column(
              children: [
                _buildSideFab(Icons.layers, onTap: _showLayerMenu),
                const SizedBox(height: 12),
                _buildSideFab(Icons.filter_list, onTap: _showFilterMenu),
                const SizedBox(height: 12),
                _buildSideFab(Icons.view_in_ar, onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const DigitalTwinScreen()));
                }),
                const SizedBox(height: 12),
                _buildSideFab(Icons.my_location, color: Colors.blueAccent, onTap: () {
                  _mapController.animateCamera(CameraUpdate.newLatLngZoom(_collegeCenter, 18));
                }),
              ],
            ),
          ),

          // 4. Bottom Legend & Data Panel
          SlidingUpPanel(
            minHeight: 280,
            maxHeight: 550,
            color: const Color(0xFF0B1015),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
            panel: _buildPanelContent(),
            body: const SizedBox.shrink(),
          ),
        ],
      ),
      // 4. Bottom Navigation Bar (Removed global nav as per request, dashboard maintains it)
      // bottomNavigationBar: _buildBottomNav(), // Removed
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF22D3EE),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SustainabilityDashboardScreen()),
        ),
        child: const Icon(Icons.analytics, color: Colors.black),
      ),
    );
  }

  void _showLayerMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0B1015),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Select Map Layer", style: GoogleFonts.syne(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              _buildLayerOption("Satellite View", Icons.satellite_alt, MapType.hybrid, setModalState),
              _buildLayerOption("Standard View", Icons.map_outlined, MapType.normal, setModalState),
              _buildLayerOption("Terrain View", Icons.terrain, MapType.terrain, setModalState),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLayerOption(String title, IconData icon, MapType type, StateSetter setModalState) {
    bool isSelected = _currentMapType == type;
    return ListTile(
      leading: Icon(icon, color: isSelected ? Colors.blueAccent : Colors.white38),
      title: Text(title, style: TextStyle(color: isSelected ? Colors.white : Colors.white70)),
      trailing: isSelected ? const Icon(Icons.check_circle, color: Colors.blueAccent) : null,
      onTap: () {
        setState(() => _currentMapType = type);
        setModalState(() {});
        Navigator.pop(context);
      },
    );
  }

  void _showFilterMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0B1015),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Map Filters", style: GoogleFonts.syne(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              _buildFilterToggle("Infrastructure Pipelines", Icons.waves, _showInfrastructure, (val) {
                setState(() => _showInfrastructure = val);
                setModalState(() {});
              }),
              _buildFilterToggle("Asset Markers", Icons.place, _showMarkers, (val) {
                setState(() => _showMarkers = val);
                setModalState(() {});
              }),
              _buildFilterToggle("Data Overlays", Icons.layers, _showAssets, (val) {
                setState(() => _showAssets = val);
                setModalState(() {});
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterToggle(String title, IconData icon, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      secondary: Icon(icon, color: Colors.blueAccent),
      title: Text(title, style: const TextStyle(color: Colors.white70, fontSize: 14)),
      value: value,
      activeColor: Colors.blueAccent,
      onChanged: onChanged,
    );
  }

  Widget _buildPillButton(String label, IconData icon, bool isActive, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? Colors.blueAccent.withValues(alpha: 0.9) : Colors.black87,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 16),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildSideFab(IconData icon, {Color color = Colors.white, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white10),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }

  Widget _buildPanelContent() {
    return const _InfraPanelContent();
  }

  Widget _buildBottomNav() {
    return const SizedBox.shrink();
  }

  Widget _buildNavIcon(IconData icon, {required Widget target}) {
    return const SizedBox.shrink();
  }
}

class _InfraPanelContent extends StatelessWidget {
  const _InfraPanelContent();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)))),
          const SizedBox(height: 20),
          Row(
            children: [
              const Icon(Icons.assignment_outlined, color: Colors.blueAccent, size: 20),
              const SizedBox(width: 10),
              Text("Water Tasks", style: GoogleFonts.syne(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 25),
          const Expanded(
            child: _InfraLegendGrid(),
          ),
          const Divider(color: Colors.white10, height: 40),
          const Text(
            "Heat Maps (Consumption), Water Infrastructure, Route Guidance",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white38, fontSize: 10, letterSpacing: 0.5),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class _InfraLegendGrid extends StatelessWidget {
  const _InfraLegendGrid();

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 2.5,
      mainAxisSpacing: 10,
      crossAxisSpacing: 20,
      children: [
        _InfraLegendItem("Water Tasks", Icons.water_drop, Colors.cyan, target: const TicketingScreen()),
        _InfraLegendItem("Pipelines", Icons.linear_scale, Colors.blue, target: null),
        _InfraLegendItem("Hostels", Icons.hotel, Colors.blueAccent, target: const DigitalTwinScreen()),
        _InfraLegendItem("Academic Blocks", Icons.school, Colors.orange, target: const SustainabilityDashboardScreen()),
        _InfraLegendItem("Academics Zones", Icons.category, Colors.amber, target: const SustainabilityDashboardScreen()),
        _InfraLegendItem("Outlets", Icons.power_settings_new, Colors.green, target: null),
        _InfraLegendItem("Buildings", Icons.business, Colors.purple, target: null),
        _InfraLegendItem("Maintenance Sites", Icons.build, Colors.redAccent, target: const TicketingScreen()),
      ],
    );
  }
}

class _InfraLegendItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final Widget? target;

  const _InfraLegendItem(this.label, this.icon, this.color, {this.target});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (target != null) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => target!));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Accessing $label functionality..."),
              backgroundColor: color.withValues(alpha: 0.8),
              duration: const Duration(seconds: 1),
            ),
          );
        }
      },
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }
}
