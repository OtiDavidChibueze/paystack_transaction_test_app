import 'package:get_it/get_it.dart';
import 'package:frontend/core/network/dio_factory.dart';
import 'package:frontend/core/network/dio_factory_urls.dart';
import 'package:frontend/features/intialize_payment/data/datasource/transactions_remote_datasource.dart';
import 'package:frontend/features/intialize_payment/data/repository/transactions_repository_impl.dart';
import 'package:frontend/features/intialize_payment/domain/repository/transactions_repository.dart';
import 'package:frontend/features/intialize_payment/domain/usecase/intialize_transaction_usecase.dart';
import 'package:frontend/features/intialize_payment/presentation/bloc/initialize_transaction_bloc.dart';

GetIt injector = GetIt.I;

Future<void> initInjector() async {
  injector.registerFactory(
    () => DioFactory.createDio(baseUrl: DioFactoryUrls.baseUrl),
  );

  // initialize transaction
  _initPayment();
}

_initPayment() {
  injector
    ..registerLazySingleton<TransactionsRemoteDatasource>(
      () => TransactionsRemoteDatasourceImpl(dio: injector()),
    )
    ..registerLazySingleton<TransactionRepository>(
      () => TransactionRepositoryImpl(remoteDatasource: injector()),
    )
    ..registerFactory(() => IntializePaymentUsecase(repository: injector()))
    ..registerLazySingleton(
      () => InitializeTransactionBloc(intializePaymentUsecase: injector()),
    );
}
