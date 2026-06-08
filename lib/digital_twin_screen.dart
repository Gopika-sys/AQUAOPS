import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'sensor_repository.dart';
import 'digital_twin_provider.dart';
import 'ticketing_screen.dart';

class DigitalTwinScreen extends StatefulWidget {
  const DigitalTwinScreen({super.key});

  @override
  State<DigitalTwinScreen> createState() => _DigitalTwinScreenState();
}

class _DigitalTwinScreenState extends State<DigitalTwinScreen> {
  final SensorRepository _repo = SensorRepository();
  final Completer<GoogleMapController> _controller = Completer();

  final nameCtrl = TextEditingController();
  final tempCtrl = TextEditingController();
  final waterCtrl = TextEditingController();
  final capCtrl = TextEditingController();
  final latCtrl = TextEditingController();
  final lngCtrl = TextEditingController();

  @override
  void dispose() {
    nameCtrl.dispose(); tempCtrl.dispose(); waterCtrl.dispose();
    capCtrl.dispose(); latCtrl.dispose(); lngCtrl.dispose();
    super.dispose();
  }

  Future<void> _moveCamera(double lat, double lng) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng(lat, lng), zoom: 16),
    ));
  }

  Future<void> _centerOnCurrentLocation() async {
    try {
      Position pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      _moveCamera(pos.latitude, pos.longitude);
    } catch (e) { debugPrint("Could not get location: $e"); }
  }

  Future<void> _showAddAssetDialog(DigitalTwinProvider provider) async {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        scrollable: true,
        title: const Text("Add New Asset"),
        content: Column(
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: "Asset Name")),
            TextField(controller: tempCtrl, decoration: const InputDecoration(labelText: "Temperature", suffixText: "°C")),
            TextField(controller: waterCtrl, decoration: const InputDecoration(labelText: "Water Level", suffixText: "%")),
            TextField(controller: capCtrl, decoration: const InputDecoration(labelText: "Capacity", suffixText: "L")),
            TextField(controller: latCtrl, decoration: const InputDecoration(labelText: "Latitude")),
            TextField(controller: lngCtrl, decoration: const InputDecoration(labelText: "Longitude")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () async {
              double lat = double.tryParse(latCtrl.text) ?? 12.9716;
              double lng = double.tryParse(lngCtrl.text) ?? 77.5946;
              await _repo.addAsset(provider.activeCollection, nameCtrl.text, lat, lng,
                  double.tryParse(tempCtrl.text) ?? 0.0, double.tryParse(waterCtrl.text) ?? 0.0, double.tryParse(capCtrl.text) ?? 0.0);
              _moveCamera(lat, lng);
              if (mounted) Navigator.pop(context);
            },
            child: const Text("Add"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DigitalTwinProvider>();
    return Scaffold(
      backgroundColor: const Color(0xFF020509),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "btn1",
            backgroundColor: Colors.white,
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TicketingScreen())),
            child: const Icon(Icons.list_alt, color: Color(0xFF3346FF)),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: "btn2",
            backgroundColor: const Color(0xFF22D3EE),
            onPressed: () => _showAddAssetDialog(provider),
            child: const Icon(Icons.add, color: Colors.black),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _repo.getCollectionStream(provider.activeCollection),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final sensorMap = { for (var doc in snapshot.data!.docs) doc.id : doc.data() as Map<String, dynamic> };
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) provider.updateAllSensors(sensorMap);
            });
          }
          return Column(
            children: [
              _buildHeader(),
              _buildDigitalTwinMap(provider),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2, padding: const EdgeInsets.all(20),
                  children: [
                    _buildMetricCard("Level", "${provider.waterLevel}%", Icons.water_drop),
                    _buildMetricCard("Temp", "${provider.temp}°C", Icons.thermostat),
                    _buildMetricCard("Capacity", "${provider.capacity}L", Icons.storage),
                    _buildMetricCard("Status", provider.pumpStatus, Icons.check_circle_outline),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDigitalTwinMap(DigitalTwinProvider provider) {
    Set<Marker> markers = provider.sensorData.entries.map((entry) {
      final data = entry.value;
      final locData = data['location'];
      double lat = 12.9716; double lng = 77.5946;
      if (locData is GeoPoint) { lat = locData.latitude; lng = locData.longitude; }
      return Marker(markerId: MarkerId(entry.key), position: LatLng(lat, lng));
    }).toSet();

    return Container(
      height: 250, margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: GoogleMap(
        initialCameraPosition: const CameraPosition(target: LatLng(12.9716, 77.5946), zoom: 12),
        onMapCreated: (c) { _controller.complete(c); _centerOnCurrentLocation(); },
        markers: markers,
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon) => Container(
    margin: const EdgeInsets.all(8),
    decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(12)),
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, color: const Color(0xFF22D3EE)), Text(title, style: const TextStyle(color: Colors.white70)), Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))]),
  );

  Widget _buildHeader() => Padding(
    padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
    child: Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Digital Twin", style: GoogleFonts.montserrat(color: Colors.white, fontSize: 20)),
              const Icon(Icons.hub, color: Color(0xFF22D3EE)),
            ],
          ),
        ),
      ],
    ),
  );
}