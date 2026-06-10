import 'package:cloud_firestore/cloud_firestore.dart';

class SensorRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Adds a new asset to the specified collection using your new simplified schema.
  Future<void> addAsset(
      String collectionName,
      String name,
      double lat,
      double lng,
      double temp,
      double waterLevel,
      double capacity,
      ) async {
    await _db.collection(collectionName).add({
      'name': name,
      'location': GeoPoint(lat, lng), // Stored as Firestore GeoPoint
      'temp': temp,
      'waterLevel': waterLevel,
      'capacity': capacity,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// Gets the stream of assets to power the map and list.
  Stream<QuerySnapshot> getCollectionStream(String collectionName) {
    return _db.collection(collectionName).snapshots();
  }

  /// Deletes an asset.
  Future<void> deleteAsset(String collectionName, String docId) async {
    await _db.collection(collectionName).doc(docId).delete();
  }
}