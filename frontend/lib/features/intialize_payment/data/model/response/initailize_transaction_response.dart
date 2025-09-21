import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
part 'initailize_transaction_response.g.dart';

@JsonSerializable()
class InitializeTransactionResponse extends Equatable {
  final bool status;
  final String message;
  final Data data;

  const InitializeTransactionResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  @override
  List<Object?> get props => [status, message, data];

  factory InitializeTransactionResponse.fromJson(Map<String, dynamic> json) =>
      _$InitializePaymentResponseFromJson(json);

  Map<String, dynamic> toJson() => _$InitializePaymentResponseToJson(this);
}

@JsonSerializable()
class Data extends Equatable {
  @JsonKey(name: 'authorization_url')
  final String authorizationUrl;
  @JsonKey(name: 'access_code')
  final String accessCode;
  final String reference;

  const Data({
    required this.authorizationUrl,
    required this.accessCode,
    required this.reference,
  });

  @override
  List<Object?> get props => [authorizationUrl, accessCode, reference];

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}
