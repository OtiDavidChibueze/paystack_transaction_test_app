import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/injector/injector.dart';
import 'package:frontend/features/intialize_payment/domain/entity/initialize_transaction_entity.dart';
import 'package:frontend/features/intialize_payment/presentation/bloc/initialize_transaction_bloc.dart';
import 'package:frontend/features/intialize_payment/presentation/bloc/initialize_transaction_event.dart';
import 'package:frontend/features/intialize_payment/presentation/bloc/initialize_transaction_state.dart';
import 'package:url_launcher/url_launcher.dart';

class InitializeTransactionPage extends StatefulWidget {
  const InitializeTransactionPage({super.key});

  @override
  State<InitializeTransactionPage> createState() =>
      _InitializePaymentPageState();
}

class _InitializePaymentPageState extends State<InitializeTransactionPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();

  String message = '';

  @override
  void dispose() {
    _emailCtrl.dispose();
    _amountCtrl.dispose();
    super.dispose();
  }

  void _clear() {
    _emailCtrl.clear();
    _amountCtrl.clear();
    setState(() {
      message = '';
    });
  }

  Future<void> _openCheckout(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      final response = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (response == true) {
        setState(() {
          message = "Redirected to checkout URL to proceed with payment.";
        });
      } else {
        message = "Could not launch checkout URL.";
      }
    } else {
      setState(() {
        message = "Could not launch checkout URL.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => injector<InitializeTransactionBloc>(),
      child:
          BlocConsumer<InitializeTransactionBloc, InitializeTransactionState>(
            listener: (context, state) {
              if (state.status == InitializeTransactionStatus.success &&
                  state.data?.data != null) {
                _openCheckout(state.data!.data.authorizationUrl);
                _clear();
              } else if (state.status == InitializeTransactionStatus.error) {
                setState(() {
                  message = state.message ?? "Payment initialization failed.";
                });
              }
            },
            builder: (context, state) {
              if (state.status == InitializeTransactionStatus.loading) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator.adaptive()),
                );
              }

              return SafeArea(
                child: Scaffold(
                  backgroundColor: Colors.grey[200],

                  body: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Text(
                                  "Make Payment",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 25,
                                  ),
                                ),

                                SizedBox(height: 20),

                                if (message.isNotEmpty)
                                  Center(
                                    child: Text(
                                      message,
                                      style: const TextStyle(
                                        color: Colors.green,
                                      ),
                                    ),
                                  ),

                                SizedBox(height: 10),

                                TextFormField(
                                  controller: _amountCtrl,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    hintStyle: TextStyle(color: Colors.grey),
                                    prefixIcon: Icon(Icons.money),

                                    // prefix: Text("₦ "),
                                    labelText: "Amount",
                                    hintText: "1000.00",
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) =>
                                      value == null || value.isEmpty
                                      ? "Amount required"
                                      : null,
                                ),
                                const SizedBox(height: 15),
                                TextFormField(
                                  controller: _emailCtrl,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: const InputDecoration(
                                    hintStyle: TextStyle(color: Colors.grey),
                                    prefixIcon: Icon(Icons.email),
                                    labelText: "Email",
                                    hintText: "example@gmail.com",
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) =>
                                      value == null || value.isEmpty
                                      ? "Email required"
                                      : null,
                                ),
                                const SizedBox(height: 50),
                                ElevatedButton(
                                  style: ButtonStyle(
                                    foregroundColor: WidgetStatePropertyAll(
                                      Colors.white,
                                    ),
                                    backgroundColor: WidgetStatePropertyAll(
                                      Colors.black,
                                    ),
                                    shape: WidgetStatePropertyAll(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    elevation: WidgetStatePropertyAll(0),
                                    textStyle: WidgetStatePropertyAll(
                                      TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                    fixedSize: WidgetStatePropertyAll(
                                      Size(double.maxFinite, 50),
                                    ),
                                  ),
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      final amount =
                                          int.parse(_amountCtrl.text) * 100;
                                      context
                                          .read<InitializeTransactionBloc>()
                                          .add(
                                            InitializeTransactionEvent(
                                              params:
                                                  InitializeTransactionEntity(
                                                    amount: amount,
                                                    email: _emailCtrl.text,
                                                  ),
                                            ),
                                          );
                                    }
                                  },
                                  child: const Text("Pay Now"),
                                ),

                                SizedBox(height: 30),

                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "By DhayveScriptSolutions",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
    );
  }
}
