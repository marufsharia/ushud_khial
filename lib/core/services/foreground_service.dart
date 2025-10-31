import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

class ForegroundService {
  static final ForegroundService _instance = ForegroundService._internal();
  factory ForegroundService() => _instance;
  ForegroundService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  bool _isRunning = false;

  Future<void> start() async {
    if (_isRunning) return;

    // Initialize the foreground task with proper configuration
    // Based on the source code, ForegroundTaskOptions might have different parameters
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'foreground_service_channel',
        channelName: 'ওষুধের খেয়াল সার্ভিস',
        channelDescription:
            'এই সার্ভিসটি আপনার ওষুধের রিমাইন্ডার নিশ্চিত সময়ে চালানোর জন্য প্রয়োজনীয়।',
        channelImportance: NotificationChannelImportance.HIGH,
        priority: NotificationPriority.HIGH,
        // Let the package use default app icon
      ),
      iosNotificationOptions: const IOSNotificationOptions(),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.once(),
      ),
    );

    // Initialize local notifications
    await _notifications.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('ic_launcher'),
      ),
    );

    // Start the foreground service
    final result = await FlutterForegroundTask.startService(
      notificationTitle: 'ওষুধের খেয়াল',
      notificationText: 'আপনার ওষুধের রিমাইন্ডার নিশ্চিত সময়ে চলছে।',
      callback: _foregroundTaskHandler,
    );

    if (result is ServiceRequestSuccess) {
      _isRunning = true;
      debugPrint("Foreground service started successfully.");
    } else if (result is ServiceRequestFailure) {
      debugPrint("Failed to start foreground service: ${result.error}");
      throw Exception("Failed to start foreground service: ${result.error}");
    }
  }

  Future<void> stop() async {
    if (!_isRunning) return;

    final result = await FlutterForegroundTask.stopService();

    if (result is ServiceRequestSuccess) {
      _isRunning = false;
      debugPrint("Foreground service stopped successfully.");
    } else if (result is ServiceRequestFailure) {
      debugPrint("Failed to stop foreground service: ${result.error}");
      throw Exception("Failed to stop foreground service: ${result.error}");
    }
  }

  // Foreground task handler - this runs in the background
  @pragma('vm:entry-point')
  static Future<void> _foregroundTaskHandler() async {
    debugPrint("Foreground task is running at: ${DateTime.now()}");

    // Update the notification periodically
    FlutterForegroundTask.updateService(
      notificationTitle: 'ওষুধের খেয়াল',
      notificationText:
          'সর্বশেষ আপডেট: ${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
    );

    // Add your medication reminder logic here
    await _checkMedicationReminders();
  }

  // Example method to check medication reminders
  static Future<void> _checkMedicationReminders() async {
    debugPrint("Checking medication reminders...");

    // Store last check time
    await FlutterForegroundTask.saveData(
      key: 'last_check_time',
      value: DateTime.now().millisecondsSinceEpoch.toString(),
    );
  }

  bool get isRunning => _isRunning;
  Future<bool> get isServiceRunning => FlutterForegroundTask.isRunningService;
}
