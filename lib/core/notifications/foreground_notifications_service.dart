import 'dart:typed_data';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

class ForegroundNotificationsService {
  ForegroundNotificationsService._();

  static const AndroidNotificationChannel _androidChannel =
      AndroidNotificationChannel(
        'banca_app_push',
        'Banca App',
        description: 'Notificaciones importantes de Banca App',
        importance: Importance.high,
      );

  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );

    await _localNotifications.initialize(settings: initializationSettings);

    final androidPlugin =
        _localNotifications
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
    await androidPlugin?.createNotificationChannel(_androidChannel);
    await androidPlugin?.requestNotificationsPermission();

    FirebaseMessaging.onMessage.listen(_showForegroundNotification);
    _initialized = true;
  }

  static Future<void> _showForegroundNotification(RemoteMessage message) async {
    final notification = message.notification;
    final title =
        notification?.title ?? _stringData(message, 'title') ?? 'Banca App';
    final body = notification?.body ?? _stringData(message, 'body') ?? '';
    final imageUrl = _resolveImageUrl(message);
    final styleInformation = await _buildBigPictureStyle(
      imageUrl: imageUrl,
      title: title,
      body: body,
    );

    await _localNotifications.show(
      id: message.hashCode,
      title: title,
      body: body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _androidChannel.id,
          _androidChannel.name,
          channelDescription: _androidChannel.description,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          styleInformation: styleInformation,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: message.messageId,
    );
  }

  static String? _resolveImageUrl(RemoteMessage message) {
    final notification = message.notification;
    return notification?.android?.imageUrl ??
        notification?.apple?.imageUrl ??
        _stringData(message, 'image') ??
        _stringData(message, 'imageUrl') ??
        _stringData(message, 'picture');
  }

  static String? _stringData(RemoteMessage message, String key) {
    final value = message.data[key];
    return value is String && value.trim().isNotEmpty ? value : null;
  }

  static Future<BigPictureStyleInformation?> _buildBigPictureStyle({
    required String? imageUrl,
    required String title,
    required String body,
  }) async {
    if (imageUrl == null || imageUrl.trim().isEmpty) {
      return null;
    }

    final imageBytes = await _downloadImageBytes(imageUrl.trim());
    if (imageBytes == null) {
      return null;
    }

    final bitmap = ByteArrayAndroidBitmap(imageBytes);
    return BigPictureStyleInformation(
      bitmap,
      contentTitle: title,
      summaryText: body,
      htmlFormatContentTitle: false,
      htmlFormatSummaryText: false,
    );
  }

  static Future<Uint8List?> _downloadImageBytes(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode < 200 || response.statusCode >= 300) {
        return null;
      }

      return response.bodyBytes;
    } catch (_) {
      return null;
    }
  }
}
