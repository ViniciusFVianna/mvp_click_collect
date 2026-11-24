import '../../../../share/util/log_util.dart';
import '../../../../share/util/result.dart';
import '../../domain/error/stores_failure.dart';
import '../../domain/model/store_model.dart';
import '../../domain/repository/stores_repository.dart';
import '../datasource/stores_datasource.dart';

class StoresRepositoryImpl implements StoresRepository {
  final StoresDatasource _datasource;

  StoresRepositoryImpl({required StoresDatasource datasource})
    : _datasource = datasource;

  @override
  Future<Result<List<StoreModel>, StoresFailure>> getStores({
    String? cep,
    String? produtoId,
  }) async {
    final response = await _datasource.getStores(
      cep: cep,
      produtoId: produtoId,
    );
    return response.when(
      success: (items) => _mapStores(items),
      exception: (error) => Failure(StoresFailure(message: error.toString())),
    );
  }

  Result<List<StoreModel>, StoresFailure> _mapStores(
    List<Map<String, dynamic>> items,
  ) {
    try {
      return Success(items.map(StoreModel.fromJson).toList());
    } catch (error) {
      errorLog(error.toString(), tag: 'StoresRepositoryImpl.getStores');
      return Failure(
        StoresFailure(message: 'Resposta inválida de lojas: $error'),
      );
    }
  }
}
