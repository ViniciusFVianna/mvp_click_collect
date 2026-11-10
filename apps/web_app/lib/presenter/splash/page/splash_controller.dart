import 'package:web_app/app/utils/command.dart';
import 'package:web_app/app/navigation/app_navigator.dart';
import 'package:web_app/presenter/home/page/home_page.dart';

class SplashController {
  Command<bool> isLoaded = Command<bool>(data: false);

  void onInit() async {
    isLoaded.setLoading(true);
    await Future.delayed(const Duration(seconds: 2));
    isLoaded.setData(true);
    AppNavigator.pushReplacement(HomePage);
  }
}
