import 'package:equatable/equatable.dart';

class InitializeTransactionEntity extends Equatable {
  final String email;
  final int amount;

  const InitializeTransactionEntity({
    required this.email,
    required this.amount,
  });

  @override
  List<Object?> get props => [email, amount];
}
