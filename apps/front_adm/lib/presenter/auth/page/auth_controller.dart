import 'package:front_adm/app/utils/command.dart';

enum AuthState {initial, loading, success, failure}
class AuthController {
  Command<AuthState> state = Command<AuthState>(data: AuthState.initial);

  void onInit(){}
}