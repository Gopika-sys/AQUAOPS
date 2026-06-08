import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'ticket_model.dart';
import 'water_map_screen.dart';
import 'main.dart'; // Assuming flutterLocalNotificationsPlugin is global here

class TicketingScreen extends StatelessWidget {
  const TicketingScreen({super.key});

  // Semantic Colors from specifications
  static const Color colorCritical = Color(0xFFFF4D4D);
  static const Color colorWarning = Color(0xFFFFB84D);
  static const Color colorPrimary = Color(0xFF4D94FF);
  static const Color colorBackground = Color(0xFF020509);
  static const Color colorCard = Color(0xFF0B1015);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppBar(
        title: Text("COMMAND TICKETS", style: GoogleFonts.syne(fontWeight: FontWeight.bold, letterSpacing: 2)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('tickets').orderBy('timestamp', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator(color: colorPrimary));
          if (snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No Active Incidents", style: GoogleFonts.montserrat(color: Colors.white24)));
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final ticket = Ticket.fromDocument(snapshot.data!.docs[index]);
              return _buildProfessionalTicketCard(context, ticket);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF22D3EE),
        onPressed: () {
          // 1. Existing Dialog logic
          _showTicketDialog(context);
          
          // 2. Navigation to the Map screen
          Navigator.push(context, MaterialPageRoute(builder: (_) => const WaterMapScreen()));
        },
        child: const Icon(Icons.map, color: Colors.black),
      ),
    );
  }

  Widget _buildProfessionalTicketCard(BuildContext context, Ticket ticket) {
    bool isCritical = ticket.severity == "CRITICAL";
    Color semanticColor = isCritical ? colorCritical : colorWarning;

    return Container(
      margin: const EdgeInsets.only(bottom: 25),
      decoration: BoxDecoration(
        color: colorCard,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: semanticColor.withValues(alpha: 0.15), width: 1.5),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.4), blurRadius: 20, offset: const Offset(0, 10))
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Column(
          children: [
            // Header Section: Status Badge & Title
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSeverityBadge(ticket.severity),
                      Text(
                        DateFormat('HH:mm | dd MMM').format(ticket.timestamp.toDate()),
                        style: GoogleFonts.montserrat(color: Colors.white24, fontSize: 10),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text(
                    ticket.title.toUpperCase(),
                    style: GoogleFonts.syne(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, color: Colors.white38, size: 12),
                      const SizedBox(width: 5),
                      Text(ticket.location, style: GoogleFonts.montserrat(color: Colors.white38, fontSize: 11)),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text(
                    ticket.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.montserrat(color: Colors.white70, fontSize: 13, height: 1.4),
                  ),
                ],
              ),
            ),

            // Workflow Section
            _buildWorkflowSection(ticket),

            // Assignments Section
            _buildAssignmentSection(context, ticket),

            // Action Button
            _buildActionButton(context, ticket),
          ],
        ),
      ),
    );
  }

  Widget _buildSeverityBadge(String severity) {
    bool isCritical = severity == "CRITICAL";
    Color color = isCritical ? colorCritical : colorWarning;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        severity,
        style: GoogleFonts.montserrat(color: color, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1),
      ),
    );
  }

  Widget _buildWorkflowSection(Ticket ticket) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.02)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("INCIDENT WORKFLOW", style: GoogleFonts.syne(color: Colors.white24, fontSize: 9, letterSpacing: 2, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Row(
            children: List.generate(4, (index) {
              int step = index + 1;
              bool isActive = step == ticket.status;
              bool isPast = step < ticket.status;
              Color activeColor = ticket.severity == "CRITICAL" ? colorCritical : colorPrimary;

              return Expanded(
                child: Row(
                  children: [
                    // Node
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isPast ? activeColor : (isActive ? Colors.transparent : Colors.white10),
                        border: isActive ? Border.all(color: activeColor, width: 2) : null,
                        boxShadow: isActive ? [BoxShadow(color: activeColor.withValues(alpha: 0.5), blurRadius: 10)] : null,
                      ),
                      child: Center(
                        child: isPast 
                          ? const Icon(Icons.check, size: 14, color: Colors.black) 
                          : Text("$step", style: TextStyle(color: isActive ? activeColor : Colors.white24, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    // Line
                    if (index < 3)
                      Expanded(
                        child: Container(
                          height: 2,
                          color: isPast ? activeColor : Colors.white10,
                        ),
                      ),
                  ],
                ),
              );
            }),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Current: ${Ticket.getStatusText(ticket.status)}", style: GoogleFonts.montserrat(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.w600)),
              if (ticket.status == 4) 
                const Icon(Icons.verified, color: Colors.greenAccent, size: 14),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAssignmentSection(BuildContext context, Ticket ticket) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: colorPrimary.withValues(alpha: 0.1),
            backgroundImage: ticket.avatarUrl != null ? NetworkImage(ticket.avatarUrl!) : null,
            child: ticket.avatarUrl == null ? const Icon(Icons.person, color: colorPrimary, size: 20) : null,
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("ASSIGNED TECHNICIAN", style: GoogleFonts.syne(color: Colors.white24, fontSize: 8, letterSpacing: 1.5)),
                Text(ticket.assignedTo, style: GoogleFonts.montserrat(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                if (ticket.status < 4) ...[
                  const SizedBox(height: 5),
                  GestureDetector(
                    onTap: () => _simulateAutomatedResponse(ticket),
                    child: Text(
                      "Simulate Automated Response",
                      style: GoogleFonts.montserrat(
                        color: Colors.greenAccent,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_horiz, color: Colors.white24),
            onPressed: () => _showManageOptions(context, ticket),
          )
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, Ticket ticket) {
    bool isCritical = ticket.severity == "CRITICAL";
    bool isResolved = ticket.status == 4;

    return InkWell(
      onTap: isResolved ? null : () async {
        HapticFeedback.mediumImpact();
        if (ticket.status < 4) {
          int newStatus = ticket.status + 1;
          await FirebaseFirestore.instance.collection('tickets').doc(ticket.id).update({'status': newStatus});
          
          if (newStatus == 4) {
            _triggerResolvedNotification(ticket.title);
          }
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: isResolved ? Colors.greenAccent.withValues(alpha: 0.05) : (isCritical ? colorCritical.withValues(alpha: 0.1) : colorPrimary.withValues(alpha: 0.1)),
          border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.05))),
        ),
        child: Center(
          child: Text(
            isResolved ? "RESOLVED & ARCHIVED" : "ADVANCE WORKFLOW PHASE",
            style: GoogleFonts.montserrat(
              color: isResolved ? Colors.greenAccent : (isCritical ? colorCritical : colorPrimary),
              fontWeight: FontWeight.bold,
              fontSize: 12,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }

  void _showTicketDialog(BuildContext context, {Ticket? ticket}) {
    final titleCtrl = TextEditingController(text: ticket?.title ?? "");
    final descCtrl = TextEditingController(text: ticket?.description ?? "");
    final locCtrl = TextEditingController(text: ticket?.location ?? "");
    final techCtrl = TextEditingController(text: ticket?.assignedTo ?? "");
    String severity = ticket?.severity ?? "WARNING";

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, setDialogState) {
        return AlertDialog(
          backgroundColor: colorCard,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(ticket == null ? "Raise Incident" : "Modify Incident", style: GoogleFonts.syne(color: Colors.white, fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDialogField(titleCtrl, "Incident Title", Icons.title),
                _buildDialogField(descCtrl, "Description", Icons.description, maxLines: 3),
                _buildDialogField(locCtrl, "Asset Location", Icons.map),
                _buildDialogField(techCtrl, "Assign Technician", Icons.person_add),
                const SizedBox(height: 15),
                DropdownButtonFormField<String>(
                  initialValue: severity,
                  dropdownColor: colorCard,
                  decoration: _dialogInputDecoration("Severity Level", Icons.warning),
                  items: ["CRITICAL", "WARNING"].map((s) => DropdownMenuItem(value: s, child: Text(s, style: const TextStyle(color: Colors.white)))).toList(),
                  onChanged: (val) => setDialogState(() => severity = val!),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text("CANCEL", style: TextStyle(color: Colors.white24))),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: colorPrimary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              onPressed: () async {
                if (ticket == null) {
                  await FirebaseFirestore.instance.collection('tickets').add({
                    'title': titleCtrl.text,
                    'description': descCtrl.text,
                    'location': locCtrl.text,
                    'assignedTo': techCtrl.text,
                    'severity': severity,
                    'status': 1,
                    'timestamp': FieldValue.serverTimestamp(),
                  });
                  if (severity == "CRITICAL") _triggerLocalNotification(titleCtrl.text);
                } else {
                  await FirebaseFirestore.instance.collection('tickets').doc(ticket.id).update({
                    'title': titleCtrl.text,
                    'description': descCtrl.text,
                    'location': locCtrl.text,
                    'assignedTo': techCtrl.text,
                    'severity': severity
                  });
                  // Trigger notification if updated to CRITICAL
                  if (severity == "CRITICAL") _triggerLocalNotification(titleCtrl.text);
                }
                if (context.mounted) Navigator.pop(context);
              },
              child: Text(ticket == null ? "CREATE" : "UPDATE", style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            )
          ],
        );
      }),
    );
  }

  Widget _buildDialogField(TextEditingController ctrl, String label, IconData icon, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: ctrl,
        maxLines: maxLines,
        style: const TextStyle(color: Colors.white),
        decoration: _dialogInputDecoration(label, icon),
      ),
    );
  }

  InputDecoration _dialogInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white38, fontSize: 12),
      prefixIcon: Icon(icon, color: colorPrimary, size: 20),
      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1))),
      focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: colorPrimary)),
    );
  }

  void _showManageOptions(BuildContext context, Ticket ticket) {
    showModalBottomSheet(
      context: context,
      backgroundColor: colorCard,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(2))),
          ListTile(
            leading: const Icon(Icons.edit_note, color: colorPrimary),
            title: const Text("Edit Incident Data"),
            onTap: () { Navigator.pop(context); _showTicketDialog(context, ticket: ticket); },
          ),
          ListTile(
            leading: const Icon(Icons.delete_forever, color: colorCritical),
            title: const Text("Delete & Close Ticket", style: TextStyle(color: colorCritical)),
            onTap: () { Navigator.pop(context); _confirmDelete(context, ticket); },
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  void _triggerLocalNotification(String title) {
    _showNotification(
      id: DateTime.now().millisecondsSinceEpoch % 100000,
      title: "🚨 CRITICAL INCIDENT",
      body: "ATTENTION: $title",
      channelId: 'high_importance_channel_v2',
      channelName: 'Critical System Alerts',
      vibration: true,
    );
  }

  void _triggerAutomatedResponseNotification(String title) {
    _showNotification(
      id: (DateTime.now().millisecondsSinceEpoch + 2) % 100000,
      title: "🛠️ RESPONSE INITIATED",
      body: "Automated protocols are addressing: $title",
      channelId: 'automated_channel',
      channelName: 'Automated Response',
      vibration: false,
    );
  }

  void _triggerResolvedNotification(String title) {
    _showNotification(
      id: (DateTime.now().millisecondsSinceEpoch + 1) % 100000,
      title: "✅ INCIDENT RESOLVED",
      body: "The issue '$title' has been successfully closed by the technician.",
      channelId: 'resolved_channel',
      channelName: 'Status Updates',
      vibration: true,
    );
  }

  void _simulateAutomatedResponse(Ticket ticket) async {
    _triggerAutomatedResponseNotification(ticket.title);

    for (int i = ticket.status + 1; i <= 4; i++) {
      await Future.delayed(const Duration(seconds: 3));
      await FirebaseFirestore.instance.collection('tickets').doc(ticket.id).update({'status': i});
      if (i == 4) {
        _triggerResolvedNotification(ticket.title);
      }
    }
  }

  void _showNotification({
    required int id,
    required String title,
    required String body,
    required String channelId,
    required String channelName,
    required bool vibration,
  }) {
    flutterLocalNotificationsPlugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          channelName,
          importance: Importance.max,
          priority: Priority.max,
          showWhen: true,
          enableVibration: vibration,
          vibrationPattern: vibration ? Int64List.fromList([0, 500, 200, 500]) : null,
          styleInformation: const BigTextStyleInformation(''),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, Ticket ticket) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: colorCard,
        title: const Text("Delete Record?", style: TextStyle(color: Colors.white)),
        content: const Text("This action cannot be undone.", style: TextStyle(color: Colors.white54)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          TextButton(
            onPressed: () { 
              FirebaseFirestore.instance.collection('tickets').doc(ticket.id).delete(); 
              Navigator.pop(ctx); 
            }, 
            child: const Text("DELETE", style: TextStyle(color: colorCritical))
          ),
        ],
      ),
    );
  }
}
