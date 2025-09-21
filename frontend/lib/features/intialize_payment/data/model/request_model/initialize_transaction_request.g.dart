// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'initialize_transaction_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InitializeTransactionRequest _$InitializePaymentRequestFromJson(
  Map<String, dynamic> json,
) => InitializeTransactionRequest(
  email: json['email'] as String,
  amount: (json['amount'] as num).toInt(),
);

Map<String, dynamic> _$InitializePaymentRequestToJson(
  InitializeTransactionRequest instance,
) => <String, dynamic>{'email': instance.email, 'amount': instance.amount};
