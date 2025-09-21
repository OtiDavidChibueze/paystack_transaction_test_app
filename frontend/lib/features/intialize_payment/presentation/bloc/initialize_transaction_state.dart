// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:frontend/features/intialize_payment/data/model/response/initailize_transaction_response.dart';

enum InitializeTransactionStatus { initial, loading, success, error }

class InitializeTransactionState extends Equatable {
  final InitializeTransactionStatus status;
  final String? message;
  final InitializeTransactionResponse? data;

  const InitializeTransactionState._({
    required this.status,
    this.message,
    this.data,
  });

  factory InitializeTransactionState.initial() =>
      InitializeTransactionState._(status: InitializeTransactionStatus.initial);

  @override
  List<Object?> get props => [status, message, data];

  InitializeTransactionState copyWith({
    InitializeTransactionStatus? status,
    String? message,
    InitializeTransactionResponse? data,
  }) {
    return InitializeTransactionState._(
      status: status ?? this.status,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }
}
