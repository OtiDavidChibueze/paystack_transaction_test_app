import 'package:fpdart/fpdart.dart';
import 'package:frontend/core/common/usecase/usecase.dart';
import 'package:frontend/core/error/failure.dart';
import 'package:frontend/features/intialize_payment/data/model/response/initailize_transaction_response.dart';
import 'package:frontend/features/intialize_payment/domain/entity/initialize_transaction_entity.dart';
import 'package:frontend/features/intialize_payment/domain/repository/transactions_repository.dart';

class IntializePaymentUsecase
    implements
        UseCase<
          Failure,
          InitializeTransactionResponse,
          InitializeTransactionEntity
        > {
  final TransactionRepository repository;

  IntializePaymentUsecase({required this.repository});

  @override
  Future<Either<Failure, InitializeTransactionResponse>> call(
    InitializeTransactionEntity params,
  ) async {
    return await repository.initializePayment(params);
  }
}
