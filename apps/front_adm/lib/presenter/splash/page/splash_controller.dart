import 'package:front_adm/app/utils/command.dart';
import 'package:front_adm/app/navigation/app_navigator.dart';
import 'package:front_adm/presenter/auth/page/auth_page.dart';

class SplashController {
  Command<bool> isLoaded = Command<bool>(data: false);

  void onInit() async {
    isLoaded.setLoading(true);
    await Future.delayed(const Duration(seconds: 2));
    isLoaded.setData(true);
    AppNavigator.pushReplacement(AuthPage);
  }
}
