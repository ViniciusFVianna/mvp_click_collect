import 'package:flutter/foundation.dart';

enum Environment { dev, qa, prod }

class AppSettings {
  final Environment environment;
  final String baseUrl;

  const AppSettings({
    this.environment = Environment.dev,
    this.baseUrl = defaultBaseUrl,
  });

  static const String defaultBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://192.168.130.121:3000',
  );

  static Uri get apiBaseUri {
    const configuredBaseUrl = String.fromEnvironment('API_BASE_URL');
    if (configuredBaseUrl.isNotEmpty) {
      return Uri.parse(configuredBaseUrl);
    }
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return Uri.parse('http://192.168.130.121:3000/');
    }
    return Uri.parse(defaultBaseUrl);
  }

  static Uri get baseUrlUri => apiBaseUri;
}
