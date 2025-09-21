import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:frontend/features/intialize_payment/domain/entity/initialize_transaction_entity.dart';
part 'initialize_transaction_request.g.dart';

@JsonSerializable()
class InitializeTransactionRequest extends InitializeTransactionEntity
    with EquatableMixin {
  const InitializeTransactionRequest({
    required super.email,
    required super.amount,
  });

  @override
  List<Object?> get props => [email, amount];

  factory InitializeTransactionRequest.fromJson(Map<String, dynamic> json) =>
      _$InitializePaymentRequestFromJson(json);

  Map<String, dynamic> toJson() => _$InitializePaymentRequestToJson(this);
}
