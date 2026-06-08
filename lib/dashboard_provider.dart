import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class DashboardProvider with ChangeNotifier {
  double _healthScore = 8.7;
  int _consumption = 12450;
  Timer? _timer;

  double get healthScore => _healthScore;
  int get consumption => _consumption;

  DashboardProvider() {
    _startSimulatedUpdates();
  }

  void _startSimulatedUpdates() {
    // Prevent duplicate timers
    _timer?.cancel();

    // Periodically update data every 3 seconds
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      _healthScore = (8.0 + Random().nextDouble() * 1.5).clamp(0.0, 10.0);
      _consumption += Random().nextInt(50);

      // Notify the UI to rebuild only the relevant parts
      notifyListeners();
    });
  }

  @override
  void dispose() {
    // Critical: Always cancel timers to prevent memory leaks
    _timer?.cancel();
    super.dispose();
  }
}