import 'package:equatable/equatable.dart';
import 'package:frontend/features/intialize_payment/domain/entity/initialize_transaction_entity.dart';

class InitializeTransactionEvent extends Equatable {
  final InitializeTransactionEntity params;

  const InitializeTransactionEvent({required this.params});

  @override
  List<Object?> get props => [params];
}
