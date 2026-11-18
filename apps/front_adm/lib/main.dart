import 'package:flutter/material.dart';
import 'app/app.dart';
import 'app/setup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Setup.I();
  runApp(const App());
}
