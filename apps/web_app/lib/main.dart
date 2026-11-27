import 'package:material_ui/material_ui.dart';

import 'app/app.dart';
import 'app/injection/injector.dart';
import 'app/navigation/router_register.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Injector.I();
  RouterRegister.I();
  runApp(const App());
}
