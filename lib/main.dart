import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'firebase_options.dart';
import 'dashboard_provider.dart';
import 'splash_screen.dart';
import 'digital_twin_provider.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
final ValueNotifier<bool> isConnectedNotifier = ValueNotifier<bool>(true);
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 1. Initialize Settings
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(
    settings: initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      debugPrint("Notification tapped: ${response.payload}");
    },
  );

  // 2. Create Notification Channel for Android 8.0+
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel_v2', // Changed ID to ensure new high-importance settings
    'Critical System Alerts',
    description: 'This channel is used for critical incident notifications.',
    importance: Importance.max,
    playSound: true,
    enableVibration: true,
  );

  final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
      flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

  await androidImplementation?.createNotificationChannel(channel);

  // 3. Request Permissions for Android 13+
  await androidImplementation?.requestNotificationsPermission();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => DigitalTwinProvider()),
      ],
      child: const AquaOpsApp(),
    ),
  );
}

class AquaOpsApp extends StatefulWidget {
  const AquaOpsApp({super.key});
  @override
  State<AquaOpsApp> createState() => _AquaOpsAppState();
}

class _AquaOpsAppState extends State<AquaOpsApp> {
  late StreamSubscription<List<ConnectivityResult>> _subscription;

  @override
  void initState() {
    super.initState();
    _checkInitialConnection();
    _subscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) {
      bool connected = result.any((r) => r != ConnectivityResult.none);
      isConnectedNotifier.value = connected;
      _showStatusSnackBar(
          connected ? "Connected to network" : "You are currently offline.",
          connected ? Colors.green : Colors.redAccent
      );
    });
  }

  Future<void> _checkInitialConnection() async {
    final result = await Connectivity().checkConnectivity();
    isConnectedNotifier.value = result.any((r) => r != ConnectivityResult.none);
  }

  void _showStatusSnackBar(String message, Color color) {
    scaffoldMessengerKey.currentState?.removeCurrentSnackBar();
    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color, duration: const Duration(seconds: 3)),
    );
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: scaffoldMessengerKey,
      debugShowCheckedModeBanner: false,
      title: 'AquaOps',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF020509),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}