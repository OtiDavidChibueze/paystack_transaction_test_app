import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:frontend/core/error/exception.dart';
import 'package:frontend/core/error/failure.dart';
import 'package:frontend/features/intialize_payment/data/datasource/transactions_remote_datasource.dart';
import 'package:frontend/features/intialize_payment/data/model/response/initailize_transaction_response.dart';
import 'package:frontend/features/intialize_payment/domain/entity/initialize_transaction_entity.dart';
import 'package:frontend/features/intialize_payment/domain/repository/transactions_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionsRemoteDatasource remoteDatasource;

  TransactionRepositoryImpl({required this.remoteDatasource});

  @override
  Future<Either<Failure, InitializeTransactionResponse>> initializePayment(
    InitializeTransactionEntity params,
  ) async {
    try {
      final response = await remoteDatasource.initializePayment(params);
      return Right(response);
    } on DioException catch (e) {
      return Left(Failure(e.response?.data['message'] ?? e.toString()));
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
