import 'package:flutter/material.dart';
import 'package:frontend/features/intialize_payment/presentation/page/initialize_transaction_page.dart';

class Transactions extends StatelessWidget {
  const Transactions({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Payment Page',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: const InitializeTransactionPage(),
    );
  }
}
