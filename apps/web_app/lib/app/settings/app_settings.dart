import 'package:flutter/foundation.dart';

enum AppEnvironment { dev, qa, prod }

class AppSettings {
  AppSettings._();

  static const _environmentName =
      String.fromEnvironment('APP_ENV', defaultValue: 'dev');
  static const _configuredApiBaseUrl = String.fromEnvironment('API_BASE_URL');

  static AppEnvironment get environment => switch (_environmentName) {
        'dev' => AppEnvironment.dev,
        'qa' => AppEnvironment.qa,
        'prod' => AppEnvironment.prod,
        _ => throw StateError('APP_ENV inválido: $_environmentName.'),
      };

  static String get apiBaseUrl {
    if (_configuredApiBaseUrl.isNotEmpty) return _configuredApiBaseUrl;
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:3000';
    }
    return 'http://localhost:3000';
  }

  static Uri get apiBaseUri => Uri.parse(apiBaseUrl);
}
