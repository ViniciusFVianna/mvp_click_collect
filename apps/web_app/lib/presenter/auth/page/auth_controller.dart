import 'package:web_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:web_app/share/util/command.dart';

class AuthController {
  final LoginUseCase _loginUseCase;

  Command<String?> tokenState = Command<String?>(data: null);
  Command<String?> errorMessage = Command<String?>(data: null);

  AuthController({required LoginUseCase loginUseCase})
    : _loginUseCase = loginUseCase;

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
