import 'package:web_app/app/navigation/app_navigator.dart';
import 'package:web_app/presenter/home/page/home_page.dart';
import 'package:web_app/share/util/command.dart';

class SplashController {
  Command<bool> isLoaded = Command<bool>(data: false);

  void onInit() async {
    isLoaded.setLoading(true);
    await Future.delayed(const Duration(seconds: 1));
    isLoaded.setData(true);
    AppNavigator.pushReplacement(HomePage);
  }
}
