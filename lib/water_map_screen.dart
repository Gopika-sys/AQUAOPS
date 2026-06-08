import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class WaterMapScreen extends StatefulWidget {
  const WaterMapScreen({super.key});

  @override
  State<WaterMapScreen> createState() => _WaterMapScreenState();
}

class _WaterMapScreenState extends State<WaterMapScreen> {
  late GoogleMapController _mapController;
  LatLng? _currentPosition;
  Set<Polyline> _polylines = {};
  
  String _selectedSource = 'My Location';
  String _selectedDestination = 'Main Water Tank';

  // Sri Eshwar College of Engineering Coordinates
  static const LatLng _collegeCenter = LatLng(10.8256, 77.0620);
  
  // Campus Locations for Routing
  final Map<String, LatLng> _campusPoints = {
    'Main Water Tank': const LatLng(10.8260, 77.0625),
    'Boys Hostel': const LatLng(10.8245, 77.0615),
    'Academic Block A': const LatLng(10.8265, 77.0610),
    'Academic Block B': const LatLng(10.8262, 77.0612),
    'Girl\'s Hostel': const LatLng(10.8235, 77.0630),
    'College Library': const LatLng(10.8255, 77.0618),
    'Campus Canteen / Cafe': const LatLng(10.8250, 77.0622),
    'Amenity Center': const LatLng(10.8248, 77.0625),
    'Sports Ground': const LatLng(10.8240, 77.0620),
    'Main Auditorium': const LatLng(10.8258, 77.0615),
    'Placement Cell': const LatLng(10.8260, 77.0618),
    'Innovation Center': const LatLng(10.8263, 77.0615),
    'Main Entrance / Gate': const LatLng(10.8240, 77.0610),
    'Parking Area': const LatLng(10.8242, 77.0612),
    'College Gym': const LatLng(10.8246, 77.0628),
    'ATM / Bank': const LatLng(10.8252, 77.0620),
    'Mechanical Block': const LatLng(10.8268, 77.0615),
    'EEE Block': const LatLng(10.8266, 77.0618),
  };

  // Markers for Campus Features
  late Set<Marker> _markers;

  @override
  void initState() {
    super.initState();
    _markers = _buildInitialMarkers();
    _determinePosition();
  }

  Set<Marker> _buildInitialMarkers() {
    return {
      Marker(
        markerId: const MarkerId('main_tank'),
        position: _campusPoints['Main Water Tank']!,
        infoWindow: const InfoWindow(title: 'Main Water Tank', snippet: 'Capacity: 50,000L'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
      ),
      Marker(
        markerId: const MarkerId('boys_hostel'),
        position: _campusPoints['Boys Hostel']!,
        infoWindow: const InfoWindow(title: 'Boys Hostel', snippet: 'Accommodation Zone'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
      Marker(
        markerId: const MarkerId('academic_block_a'),
        position: _campusPoints['Academic Block A']!,
        infoWindow: const InfoWindow(title: 'Academic Block A', snippet: 'Dept of CSE & IT'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      ),
      Marker(
        markerId: const MarkerId('cafe'),
        position: _campusPoints['Campus Canteen / Cafe']!,
        infoWindow: const InfoWindow(title: 'Campus Cafe', snippet: 'Refreshments & Food Court'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
      Marker(
        markerId: const MarkerId('amenity'),
        position: _campusPoints['Amenity Center']!,
        infoWindow: const InfoWindow(title: 'Amenity Center', snippet: 'Student Services'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
      ),
      Marker(
        markerId: const MarkerId('sports'),
        position: _campusPoints['Sports Ground']!,
        infoWindow: const InfoWindow(title: 'Sports Ground', snippet: 'Football & Athletics'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
      ),
      Marker(
        markerId: const MarkerId('auditorium'),
        position: _campusPoints['Main Auditorium']!,
        infoWindow: const InfoWindow(title: 'Main Auditorium', snippet: 'Events & Seminars'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      ),
      Marker(
        markerId: const MarkerId('entrance'),
        position: _campusPoints['Main Entrance / Gate']!,
        infoWindow: const InfoWindow(title: 'Main Gate', snippet: 'Campus Entry Point'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
      Marker(
        markerId: const MarkerId('parking'),
        position: _campusPoints['Parking Area']!,
        infoWindow: const InfoWindow(title: 'Visitor Parking', snippet: 'Safe Parking Zone'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
      ),
      Marker(
        markerId: const MarkerId('gym'),
        position: _campusPoints['College Gym']!,
        infoWindow: const InfoWindow(title: 'Student Gym', snippet: 'Fitness Center'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
      ),
    };
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) return;

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });
  }

  Future<void> _getDirections() async {
    LatLng start = _selectedSource == 'My Location' 
        ? (_currentPosition ?? _collegeCenter) 
        : _campusPoints[_selectedSource]!;
    LatLng end = _campusPoints[_selectedDestination]!;

    PolylinePoints polylinePoints = PolylinePoints(apiKey: "AIzaSyAJGUYUdhVOmp1DoDe640xRLCE7JjFZdMw");
    
    // Using the API Key found in AndroidManifest.xml
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      request: PolylineRequest(
        origin: PointLatLng(start.latitude, start.longitude),
        destination: PointLatLng(end.latitude, end.longitude),
        mode: TravelMode.walking,
      ),
    );

    if (result.points.isNotEmpty) {
      List<LatLng> polylineCoordinates = result.points
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList();

      setState(() {
        _polylines = {
          Polyline(
            polylineId: const PolylineId('accurate_route'),
            points: polylineCoordinates,
            color: Colors.cyanAccent,
            width: 6,
            jointType: JointType.round,
            startCap: Cap.roundCap,
            endCap: Cap.roundCap,
          ),
        };
      });

      _mapController.animateCamera(CameraUpdate.newLatLngBounds(
        _getBounds(polylineCoordinates),
        100,
      ));
    } else {
      // Fallback: Draw a straight line if Directions API fails or has no route
      setState(() {
        _polylines = {
          Polyline(
            polylineId: const PolylineId('fallback_route'),
            points: [start, end],
            color: Colors.cyan.withValues(alpha: 0.5),
            width: 4,
            patterns: [PatternItem.dash(10), PatternItem.gap(10)],
          ),
        };
      });
      _mapController.animateCamera(CameraUpdate.newLatLngBounds(
        _getBounds([start, end]),
        100,
      ));
    }
  }

  LatLngBounds _getBounds(List<LatLng> points) {
    double minLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLat = points.first.latitude;
    double maxLng = points.first.longitude;

    for (var point in points) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  // Initial map style (Professional Hybrid Style for better visibility)
  final String _mapStyle = '''
  [
    {"elementType":"geometry","stylers":[{"color":"#1d2c33"}]},
    {"elementType":"labels.text.fill","stylers":[{"color":"#8ec3b9"}]},
    {"elementType":"labels.text.stroke","stylers":[{"color":"#1a3646"}]},
    {"featureType":"administrative.land_parcel","elementType":"labels.text.fill","stylers":[{"color":"#64779e"}]},
    {"featureType":"landscape.man_made","elementType":"geometry.stroke","stylers":[{"color":"#334e58"}]},
    {"featureType":"poi","elementType":"geometry","stylers":[{"color":"#283d6a"}]},
    {"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#6f9ba5"}]},
    {"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#263c3f"}]},
    {"featureType":"road","elementType":"geometry","stylers":[{"color":"#304a7d"}]},
    {"featureType":"road","elementType":"labels.text.fill","stylers":[{"color":"#98a5be"}]},
    {"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#2c6675"}]},
    {"featureType":"water","elementType":"geometry","stylers":[{"color":"#0e1626"}]}
  ]''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.black54,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ),
      body: SlidingUpPanel(
        minHeight: 280,
        maxHeight: 600,
        color: const Color(0xFF0B1015),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        panel: _buildBottomPanel(),
        body: GoogleMap(
          initialCameraPosition: const CameraPosition(target: _collegeCenter, zoom: 18),
          markers: _markers,
          polylines: _polylines,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          mapType: MapType.hybrid, // Satellite view with labels for maximum visibility
          onMapCreated: (controller) {
            _mapController = controller;
          },
        ),
      ),
    );
  }

  Widget _buildBottomPanel() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 20),
            const Text("Sri Eshwar Campus Map", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const Text("Precision Route Guidance System", style: TextStyle(color: Colors.cyan, fontSize: 12)),
            
            const SizedBox(height: 25),
            
            // Source Dropdown
            _buildRouteDropdown(
              label: "START POINT",
              value: _selectedSource,
              items: ['My Location', ..._campusPoints.keys],
              onChanged: (val) => setState(() => _selectedSource = val!),
            ),
            
            const SizedBox(height: 15),
            
            // Destination Dropdown
            _buildRouteDropdown(
              label: "DESTINATION",
              value: _selectedDestination,
              items: _campusPoints.keys.toList(),
              onChanged: (val) => setState(() => _selectedDestination = val!),
            ),

            const SizedBox(height: 25),
            
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyan,
                foregroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 4,
              ),
              onPressed: _getDirections,
              icon: const Icon(Icons.directions_outlined, weight: 700),
              label: const Text("GENERATE PRECISE ROUTE", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)),
            ),
            
            const SizedBox(height: 25),
            const Text("LEGEND", style: TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
            const SizedBox(height: 10),
            _buildLegendGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildRouteDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white10),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              dropdownColor: const Color(0xFF1A1F25),
              style: const TextStyle(color: Colors.white, fontSize: 14),
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.cyan),
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLegendGrid() {
    final items = [
      {"name": "Water / Utilities", "color": Colors.cyan},
      {"name": "Hostels", "color": Colors.blue},
      {"name": "Academic", "color": Colors.orange},
      {"name": "Food / Cafe", "color": Colors.green},
      {"name": "Student Services", "color": Colors.purple},
      {"name": "Sports / Grounds", "color": Colors.redAccent},
    ];
    return GridView.count(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 3.5,
      children: items.map((item) => Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(shape: BoxShape.circle, color: item['color'] as Color),
          ),
          const SizedBox(width: 10),
          Text(item['name'] as String, style: const TextStyle(color: Colors.white70, fontSize: 11)),
        ],
      )).toList(),
    );
  }
}