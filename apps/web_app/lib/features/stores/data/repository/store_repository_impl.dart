import '../../../../share/util/log_util.dart';
import '../../../../share/util/result.dart';
import '../../domain/error/store_failure.dart';
import '../../domain/model/store_model.dart';
import '../../domain/repository/store_repository.dart';
import '../datasource/store_datasource.dart';

class StoreRepositoryImpl implements StoreRepository {
  final StoreDatasource _datasource;

  const StoreRepositoryImpl({required StoreDatasource dataSource})
      : _datasource = dataSource;

  @override
  Future<Result<List<StoreModel>, StoreFailure>> getStores({
    String? cep,
    String? produtoId,
  }) async {
    final response = await _datasource.getStores(
      cep: cep,
      produtoId: produtoId,
    );
    return response.when(
      success: (records) {
        try {
          return Success<List<StoreModel>, StoreFailure>(
            records.map(StoreModel.fromMap).toList(),
          );
        } catch (error) {
          errorLog(error.toString(), tag: 'StoreRepositoryImpl.getStores');
          return Failure<List<StoreModel>, StoreFailure>(
            StoreFailure(error.toString()),
          );
        }
      },
      exception: (exception) => Failure(StoreFailure.fromException(exception)),
    );
  }
}
