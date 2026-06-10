import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:math';

class DigitalTwinProvider with ChangeNotifier {
  // --- STATE ---
  String _activeCollection = 'devices';
  Map<String, dynamic> _sensorData = {};
  Timer? _simTimer;

  // Metrics for Twin Screen
  double _waterLevel = 0.0;
  double _temp = 0.0;
  double _capacity = 0.0;
  String _pumpStatus = "Idle";

  // Metrics for Dashboard Screen
  double _averageLevel = 0.0;
  bool _isGlobalAlarm = false;
  String _mixerTemp = "0°C";

  // Sustainability Metrics (0-100)
  double _waterEfficiency = 85.0;
  double _energyEfficiency = 78.0;
  double _ticketResolutionRate = 92.0;
  double _treeCoverage = 65.0;
  double _carbonReduction = 40.0;
  double _waterQuality = 88.0;

  double _sustainabilityHealth = 84.2;
  
  // Live Counters
  int _treeCount = 1250;
  int _todayPlantation = 12;
  int _monthlyGrowth = 87;
  
  double _reservoirCapacity = 78.0; // %
  double _availableWater = 1.8; // Million Liters
  double _dailyConsumption = 12500; // Liters
  
  bool _hasActiveAnomaly = false;
  String _anomalyType = "None";

  DigitalTwinProvider() {
    _startSimulation();
  }

  // --- GETTERS ---
  String get activeCollection => _activeCollection;
  Map<String, dynamic> get sensorData => _sensorData;

  double get waterLevel => _waterLevel;
  double get temp => _temp;
  double get capacity => _capacity;
  String get pumpStatus => _pumpStatus;

  double get averageLevel => _averageLevel;
  bool get isGlobalAlarm => _isGlobalAlarm;
  String get mixerTemp => _mixerTemp;

  double get waterEfficiency => _waterEfficiency;
  double get energyEfficiency => _energyEfficiency;
  double get ticketResolutionRate => _ticketResolutionRate;
  double get treeCoverage => _treeCoverage;
  double get carbonReduction => _carbonReduction;
  double get waterQuality => _waterQuality;
  double get sustainabilityHealth => _sustainabilityHealth;

  int get treeCount => _treeCount;
  int get todayPlantation => _todayPlantation;
  int get monthlyGrowth => _monthlyGrowth;
  double get reservoirCapacity => _reservoirCapacity;
  double get availableWater => _availableWater;
  double get dailyConsumption => _dailyConsumption;

  bool get hasActiveAnomaly => _hasActiveAnomaly;
  String get anomalyType => _anomalyType;

  // --- LOGIC ---
  void _calculateHealthScore() {
    _sustainabilityHealth = (_waterEfficiency * 0.25) +
        (_energyEfficiency * 0.20) +
        (_ticketResolutionRate * 0.15) +
        (_treeCoverage * 0.15) +
        (_carbonReduction * 0.10) +
        (_waterQuality * 0.15);
    notifyListeners();
  }

  void _startSimulation() {
    _simTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      final random = Random();
      
      // Simulating slight fluctuations
      _waterEfficiency += (random.nextDouble() * 2 - 1);
      _energyEfficiency += (random.nextDouble() * 2 - 1);
      _reservoirCapacity -= 0.1;
      _dailyConsumption += (random.nextDouble() * 100 - 50);

      // Clamp values
      _waterEfficiency = _waterEfficiency.clamp(0.0, 100.0);
      _energyEfficiency = _energyEfficiency.clamp(0.0, 100.0);
      
      if (_reservoirCapacity < 0) _reservoirCapacity = 100;

      _calculateHealthScore();
    });
  }

  String get advisorRecommendation {
    if (_reservoirCapacity < 40) {
      return "Campus water reserves are declining. Immediate water conservation measures recommended. Increase rainwater harvesting and plant additional trees to improve groundwater recharge.";
    }
    if (_treeCoverage < 70) {
      return "Tree coverage is below sustainability targets. Plant 100 additional trees near parking zones and academic blocks.";
    }
    return "Sustainability levels are optimal. Continue monitoring real-time data for peak efficiency.";
  }

  void setActiveCollection(String name) {
    _activeCollection = name;
    notifyListeners();
  }

  void updateAllSensors(Map<String, dynamic> data) {
    if (mapEquals(_sensorData, data)) return;
    _sensorData = Map<String, dynamic>.from(data);

    if (_sensorData.isNotEmpty) {
      final firstAsset = _sensorData.values.first;
      _waterLevel = (firstAsset['waterLevel'] ?? 0.0).toDouble();
      _temp = (firstAsset['temp'] ?? 0.0).toDouble();
      _capacity = (firstAsset['capacity'] ?? 0.0).toDouble();
      _pumpStatus = firstAsset['pump_state']?.toString() ?? "Idle";

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

  @override
  void dispose() {
    _simTimer?.cancel();
    super.dispose();
  }
}
