import 'package:flutter_test/flutter_test.dart';
import 'package:front_adm/app/injection/injector.dart';
import 'package:front_adm/features/auth/domain/usecases/login_usecase.dart';
import 'package:front_adm/presenter/auth/page/auth_controller.dart';
import 'package:get_it/get_it.dart';

void main() {
  group('AuthController Test', () {
    late AuthController controller;

    setUp(() {
      GetIt.I.reset();
      Injector.I();
      controller = AuthController(GetIt.I<LoginUseCase>());
    });

    test('deve executar o fluxo de login do controller', () async {
      await controller.login('admin@megaloja.com', '123456');

      expect(controller.tokenState.isLoading, isFalse);
      expect(controller.tokenState.data != null || controller.errorMessage.data != null, isTrue);
    });
  });
}
