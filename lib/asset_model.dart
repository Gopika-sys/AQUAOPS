import 'package:cloud_firestore/cloud_firestore.dart';

class Asset {
  final String id;
  final String name;
  final GeoPoint location;
  final double temp;
  final double waterLevel;
  final double capacity;

  Asset({required this.id, required this.name, required this.location,
    required this.temp, required this.waterLevel, required this.capacity});

  factory Asset.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Asset(
      id: doc.id,
      name: data['name'] ?? '',
      location: data['location'] as GeoPoint,
      temp: (data['temp'] ?? 0).toDouble(),
      waterLevel: (data['waterLevel'] ?? 0).toDouble(),
      capacity: (data['capacity'] ?? 0).toDouble(),
    );
  }
}