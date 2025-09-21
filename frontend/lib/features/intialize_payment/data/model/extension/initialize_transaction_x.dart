import 'package:frontend/features/intialize_payment/data/model/request_model/initialize_transaction_request.dart';
import 'package:frontend/features/intialize_payment/domain/entity/initialize_transaction_entity.dart';

extension InitializePaymentX on InitializeTransactionEntity {
  InitializeTransactionRequest toRequestModel() {
    return InitializeTransactionRequest(email: email, amount: amount);
  }
}
