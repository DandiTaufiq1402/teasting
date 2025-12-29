import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/services.dart'; // Penting untuk fitur Copy

// Handler untuk background message (harus di luar class/top-level)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Jika perlu melakukan sesuatu saat background, misal simpan ke local storage
  print("Handling a background message: ${message.messageId}");
}

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    // 1. Meminta Izin Notifikasi
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('Izin notifikasi diberikan oleh user.');
    } else {
      print('Izin notifikasi ditolak/belum diberikan.');
    }

    // 2. Set Background Handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // 3. Setup Notifikasi Lokal (agar muncul saat aplikasi dibuka/foreground di Android)
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    
    // Setup untuk iOS (opsional jika nanti perlu)
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings();

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await _localNotifications.initialize(initializationSettings);

    // 4. Setup Channel Notifikasi Android (Penting untuk Android 8+)
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description: 'This channel is used for important notifications.', // description
      importance: Importance.max,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // 5. Listener Pesan saat Foreground (Aplikasi sedang dibuka)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Pesan diterima saat foreground: ${message.notification?.title}');
      
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      // Tampilkan notifikasi lokal jika ada datanya
      if (notification != null && android != null) {
        _localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              icon: android.smallIcon,
            ),
          ),
        );
      }
    });

    // 6. Cek Token FCM & AUTO COPY
    final fcmToken = await _firebaseMessaging.getToken();
    print('FCM Token Anda: $fcmToken');

    // --- BAGIAN INI YANG MENYALIN OTOMATIS ---
    if (fcmToken != null) { 
      await Clipboard.setData(ClipboardData(text: fcmToken));
      print("📋 SUKSES! Token sudah dicopy ke Clipboard HP Anda.");
      print("   (Silakan langsung 'Paste' di website Firebase)");
    }
  }
}