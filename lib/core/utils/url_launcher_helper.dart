import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlLauncherHelper {
  UrlLauncherHelper._();

  static Future<void> call(BuildContext context, String number) =>
      _launch(context, Uri(scheme: 'tel', path: number.trim()), 'dialer');

  static Future<void> sms(BuildContext context, String number) =>
      _launch(context, Uri(scheme: 'sms', path: number.trim()), 'messaging app');

  static Future<void> email(BuildContext context, String address) =>
      _launch(context, Uri(scheme: 'mailto', path: address.trim()), 'email app');

  static Future<void> _launch(
    BuildContext context,
    Uri uri,
    String appName,
  ) async {
    final messenger = ScaffoldMessenger.of(context);

    if (uri.path.isEmpty) {
      messenger.showSnackBar(
        const SnackBar(content: Text('This detail is not available.')),
      );
      return;
    }

    var opened = false;
    try {
      opened = await launchUrl(uri);
    } catch (_) {
      opened = false;
    }

    if (!opened) {
      messenger.showSnackBar(
        SnackBar(content: Text('Could not open the $appName.')),
      );
    }
  }
}