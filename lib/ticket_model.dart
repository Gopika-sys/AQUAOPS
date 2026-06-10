import 'package:cloud_firestore/cloud_firestore.dart';

class Ticket {
  final String id;
  final String assetId;
  final String title;
  final String description;
  final String severity; // CRITICAL, WARNING
  final int status;      // 1: Reported, 2: Assigned, 3: In Progress, 4: Resolved
  final String location;
  final String assignedTo;
  final String? avatarUrl;
  final Timestamp timestamp;

  Ticket({
    required this.id,
    required this.assetId,
    required this.title,
    required this.description,
    required this.severity,
    required this.status,
    required this.location,
    required this.assignedTo,
    this.avatarUrl,
    required this.timestamp,
  });

  factory Ticket.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Ticket(
      id: doc.id,
      assetId: data['assetId'] ?? 'N/A',
      title: data['title'] ?? 'New Incident',
      description: data['description'] ?? 'No description provided.',
      severity: data['severity'] ?? 'WARNING',
      status: data['status'] ?? 1,
      location: data['location'] ?? 'Main Campus',
      assignedTo: data['assignedTo'] ?? 'Unassigned',
      avatarUrl: data['avatarUrl'],
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }

  static String getStatusText(int status) {
    switch (status) {
      case 1: return "REPORTED";
      case 2: return "ASSIGNED";
      case 3: return "IN PROGRESS";
      case 4: return "RESOLVED";
      default: return "UNKNOWN";
    }
  }
}
