import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:frontend/core/error/exception.dart';
import 'package:frontend/core/network/dio_factory_urls.dart';
import 'package:frontend/features/intialize_payment/data/model/extension/initialize_transaction_x.dart';
import 'package:frontend/features/intialize_payment/data/model/response/initailize_transaction_response.dart';
import 'package:frontend/features/intialize_payment/domain/entity/initialize_transaction_entity.dart';

abstract class TransactionsRemoteDatasource {
  Future<InitializeTransactionResponse> initializePayment(
    InitializeTransactionEntity params,
  );
}

class TransactionsRemoteDatasourceImpl implements TransactionsRemoteDatasource {
  final Dio dio;

  TransactionsRemoteDatasourceImpl({required this.dio});

  @override
  Future<InitializeTransactionResponse> initializePayment(
    InitializeTransactionEntity params,
  ) async {
    try {
      final requestModel = params.toRequestModel();

      final response = await dio.post(
        '${DioFactoryUrls.baseUrl}/transaction/initialize',
        data: jsonEncode(requestModel.toJson()),
      );

      return InitializeTransactionResponse.fromJson(response.data);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
