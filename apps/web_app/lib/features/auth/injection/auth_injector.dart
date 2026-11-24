import 'package:get_it/get_it.dart';
import '../../../../app/injection/injector_base.dart';
import '../../../../presenter/auth/page/auth_controller.dart';
import '../../../../share/boundaries/secure_storage_facade.dart';
import '../../../../share/network/custom_client_http.dart';
import '../data/datasource/auth_datasource.dart';
import '../data/datasource/auth_datasource_impl.dart';
import '../data/repository/auth_repository_impl.dart';
import '../domain/repository/auth_repository.dart';
import '../domain/usecases/get_token_usecase.dart';
import '../domain/usecases/login_usecase.dart';
import '../domain/usecases/logout_usecase.dart';

class AuthInjector implements InjectorBase {
  @override
  void call() {
    GetIt.I.registerFactory<AuthDatasource>(
      () => AuthDatasourceImpl(http: GetIt.I<CustomClientHttp>()),
    );
    GetIt.I.registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(
        datasource: GetIt.I<AuthDatasource>(),
        secureStorage: GetIt.I<SecureStorageFacade>(),
      ),
    );
    GetIt.I.registerFactory<LoginUseCase>(
      () => LoginUseCaseImpl(repository: GetIt.I<AuthRepository>()),
    );
    GetIt.I.registerFactory<LogoutUseCase>(
      () => LogoutUseCaseImpl(repository: GetIt.I<AuthRepository>()),
    );
    GetIt.I.registerFactory<GetTokenUseCase>(
      () => GetTokenUseCaseImpl(repository: GetIt.I<AuthRepository>()),
    );
    GetIt.I.registerFactory<AuthController>(
      () => AuthController(GetIt.I<LoginUseCase>()),
    );
  }
}
