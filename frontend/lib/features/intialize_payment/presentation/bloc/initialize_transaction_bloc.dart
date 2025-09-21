import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/intialize_payment/domain/entity/initialize_transaction_entity.dart';

import 'package:frontend/features/intialize_payment/domain/usecase/intialize_transaction_usecase.dart';
import 'package:frontend/features/intialize_payment/presentation/bloc/initialize_transaction_event.dart';
import 'package:frontend/features/intialize_payment/presentation/bloc/initialize_transaction_state.dart';

class InitializeTransactionBloc
    extends Bloc<InitializeTransactionEvent, InitializeTransactionState> {
  final IntializePaymentUsecase _intializePaymentUsecase;

  InitializeTransactionBloc({
    required IntializePaymentUsecase intializePaymentUsecase,
  }) : _intializePaymentUsecase = intializePaymentUsecase,
       super(InitializeTransactionState.initial()) {
    on<InitializeTransactionEvent>(_onInitializePayment);
  }

  Future<void> _onInitializePayment(
    InitializeTransactionEvent event,
    Emitter<InitializeTransactionState> emit,
  ) async {
    emit(state.copyWith(status: InitializeTransactionStatus.loading));

    final res = await _intializePaymentUsecase(
      InitializeTransactionEntity(
        email: event.params.email,
        amount: event.params.amount,
      ),
    );

    res.fold(
      (l) {
        emit(
          state.copyWith(
            status: InitializeTransactionStatus.error,
            message: l.message,
          ),
        );
      },
      (r) {
        emit(
          state.copyWith(status: InitializeTransactionStatus.success, data: r),
        );
      },
    );
  }
}
