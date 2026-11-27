import 'dart:developer' as dev;
import 'package:flutter/foundation.dart';

void successLog(String message, {String tag = 'LOG', Map<String, dynamic>? data}) {
  if (kDebugMode) {
    dev.log('✅ [$tag] $message ${data != null ? '- $data' : ''}');
  }
}

void errorLog(String message, {String tag = 'LOG', Map<String, dynamic>? data}) {
  if (kDebugMode) {
    dev.log('❌ [$tag] $message ${data != null ? '- $data' : ''}');
  }
}

void debugLog(String message, {String tag = 'LOG', Map<String, dynamic>? data}) {
  if (kDebugMode) {
    dev.log('🐛 [$tag] $message ${data != null ? '- $data' : ''}');
  }
}

void infoLog(String message, {String tag = 'LOG', Map<String, dynamic>? data}) {
  if (kDebugMode) {
    dev.log('ℹ️ [$tag] $message ${data != null ? '- $data' : ''}');
  }
}
