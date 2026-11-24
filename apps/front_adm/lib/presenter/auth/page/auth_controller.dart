import 'package:front_adm/features/auth/domain/usecases/login_usecase.dart';
import 'package:front_adm/share/util/command.dart';

class AuthController {
  final LoginUseCase _loginUseCase;

  Command<String?> tokenState = Command<String?>(data: null);
  Command<String?> errorMessage = Command<String?>(data: null);

  AuthController(this._loginUseCase);

  Future<void> login(String email, String password) async {
    tokenState.setLoading(true);
    errorMessage.setData(null);

    final result = await _loginUseCase(email, password);

    result.when(
      success: (token) {
        tokenState.setData(token);
        tokenState.setLoading(false);
      },
      exception: (failure) {
        errorMessage.setData(failure.message);
        tokenState.setLoading(false);
      },
    );
  }
}
