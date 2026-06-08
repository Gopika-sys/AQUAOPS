import 'package:flutter/foundation.dart';

class DigitalTwinProvider with ChangeNotifier {
  // --- STATE ---
  String _activeCollection = 'devices';
  Map<String, dynamic> _sensorData = {};

  // Metrics for Twin Screen
  double _waterLevel = 0.0;
  double _temp = 0.0;
  double _capacity = 0.0;
  String _pumpStatus = "Idle";

  // Metrics for Dashboard Screen
  double _averageLevel = 0.0;
  bool _isGlobalAlarm = false;
  String _mixerTemp = "0°C";

  // --- GETTERS (Dashboard & Twin screens look for these) ---
  String get activeCollection => _activeCollection;
  Map<String, dynamic> get sensorData => _sensorData;

  double get waterLevel => _waterLevel;
  double get temp => _temp;
  double get capacity => _capacity;
  String get pumpStatus => _pumpStatus;

  double get averageLevel => _averageLevel;
  bool get isGlobalAlarm => _isGlobalAlarm;
  String get mixerTemp => _mixerTemp;

  // --- LOGIC ---
  void setActiveCollection(String name) {
    _activeCollection = name;
    notifyListeners();
  }

  void updateAllSensors(Map<String, dynamic> data) {
    if (mapEquals(_sensorData, data)) return;
    _sensorData = Map<String, dynamic>.from(data);

    if (_sensorData.isNotEmpty) {
      // 1. Update Twin Screen Data (from first asset)
      final firstAsset = _sensorData.values.first;
      _waterLevel = (firstAsset['waterLevel'] ?? 0.0).toDouble();
      _temp = (firstAsset['temp'] ?? 0.0).toDouble();
      _capacity = (firstAsset['capacity'] ?? 0.0).toDouble();
      _pumpStatus = firstAsset['pump_state']?.toString() ?? "Idle";

      // 2. Update Dashboard Screen Metrics
      double totalLevel = 0.0;
      bool alarmTriggered = false;

      _sensorData.forEach((id, val) {
        final levelRaw = val['level'] ?? 0;
        double level = (levelRaw is num) ? levelRaw.toDouble() : double.tryParse(levelRaw.toString()) ?? 0.0;
        totalLevel += level;
        if (level < 15.0) alarmTriggered = true;

        if (val.containsKey('mixer_temp')) _mixerTemp = "${val['mixer_temp']}°C";
      });

      _averageLevel = totalLevel / _sensorData.length;
      _isGlobalAlarm = alarmTriggered;

      notifyListeners();
    }
  }
}