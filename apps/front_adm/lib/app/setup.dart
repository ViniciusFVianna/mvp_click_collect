import 'injection/injector.dart';
import 'navigation/router_register.dart';

class Setup {
  Setup._();
  static Setup? _instance;
  static Setup get I => _instance ??= Setup._();

  static void dispose() {
    _instance = null;
  }

  Future<void> call() async {
    Injector.I();
    RouterRegister.I();
  }
}
