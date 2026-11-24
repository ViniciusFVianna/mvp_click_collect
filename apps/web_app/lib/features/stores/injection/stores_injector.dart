import 'package:get_it/get_it.dart';
import 'package:web_app/app/injection/injector_base.dart';
import 'package:web_app/presenter/store_selector/page/store_selector_controller.dart';
import 'package:web_app/share/network/custom_client_http.dart';

import '../data/datasource/stores_datasource.dart';
import '../data/datasource/stores_datasource_impl.dart';
import '../data/repository/stores_repository_impl.dart';
import '../domain/repository/stores_repository.dart';
import '../domain/usecases/get_stores_usecase.dart';

class StoresInjector implements InjectorBase {
  @override
  void call() {
    GetIt.I.registerFactory<StoresDatasource>(
      () => StoresDatasourceImpl(http: GetIt.I<CustomClientHttp>()),
    );
    GetIt.I.registerFactory<StoresRepository>(
      () => StoresRepositoryImpl(datasource: GetIt.I<StoresDatasource>()),
    );
    GetIt.I.registerFactory<GetStoresUseCase>(
      () => GetStoresUseCaseImpl(repository: GetIt.I<StoresRepository>()),
    );
    GetIt.I.registerFactory<StoreSelectorController>(
      () => StoreSelectorController(getStores: GetIt.I<GetStoresUseCase>()),
    );
  }
}
