import 'package:design_system/design_system.dart';
import 'package:material_ui/material_ui.dart';
import 'navigation/router_register.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Click & Collect E-Commerce',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryBase,
          primary: AppColors.primaryBase,
          secondary: AppColors.accentOrange,
          surface: AppColors.backgroundCard,
        ),
        scaffoldBackgroundColor: AppColors.backgroundLight,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primaryBase,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
        ),
      ),
      themeMode: ThemeMode.light,
      routerConfig: RouterRegister.I.router,
    );
  }
}
