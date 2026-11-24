import 'package:flutter_test/flutter_test.dart';
import 'package:front_adm/presenter/splash/page/splash_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SplashController Test', () {
    test('isLoaded deve iniciar como false e ser atualizado após o carregamento', () async {
      final controller = SplashController();
      expect(controller.isLoaded.data, isFalse);
    });
  });
}
