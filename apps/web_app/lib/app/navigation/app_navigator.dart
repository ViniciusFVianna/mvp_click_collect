import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'router_register.dart';

class AppNavigator {
  static BuildContext? get _context =>
      RouterRegister.I.globalContext.currentContext;

  static Future<dynamic> popAndPush(Type page, {Object? extra}) async {
    _context?.pop();
    return await _context?.push('/$page', extra: extra);
  }

  static Future<dynamic> push(Type page, {Object? extra}) async {
    return await _context?.push('/$page', extra: extra);
  }

  static void pushReplacement(Type page, {Object? extra}) {
    _context?.go('/$page', extra: extra);
  }

  static void pop({dynamic result}) {
    if (_context != null && GoRouter.of(_context!).canPop()) {
      _context?.pop(result);
    }
  }

  static String? get currentRoute =>
      _context != null ? GoRouter.of(_context!).state.fullPath : null;
}
