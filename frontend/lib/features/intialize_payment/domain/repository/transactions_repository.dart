import 'package:fpdart/fpdart.dart';
import 'package:frontend/core/error/failure.dart';
import 'package:frontend/features/intialize_payment/data/model/response/initailize_transaction_response.dart';
import 'package:frontend/features/intialize_payment/domain/entity/initialize_transaction_entity.dart';

abstract class TransactionRepository {
  Future<Either<Failure, InitializeTransactionResponse>> initializePayment(
    InitializeTransactionEntity params,
  );
}
