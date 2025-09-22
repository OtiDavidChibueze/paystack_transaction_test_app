import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/animation/animation_enum.dart';
import 'package:frontend/core/animation/animation_service.dart';
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
      child: BlocConsumer<InitializeTransactionBloc, InitializeTransactionState>(
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

          return Scaffold(
            body: CustomPaint(
              painter: BackgroundPainter(),
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: SafeArea(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 40),
                          AnimationService(
                            type: AnimationType.slide,
                            slideDirection: SlideDirection.up,
                            duration: Duration(seconds: 2),
                            delay: Duration(seconds: 3),
                            curve: Curves.easeIn,

                            child: const Text(
                              "Make a Payment",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 32,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          AnimationService(
                            type: AnimationType.slide,
                            slideDirection: SlideDirection.right,
                            duration: Duration(seconds: 2),
                            delay: Duration(seconds: 3),
                            child: const Text(
                              "Enter your details below to proceed.",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          Card(
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    if (message.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 16.0,
                                        ),
                                        child: Text(
                                          message,
                                          style: TextStyle(
                                            color:
                                                message.contains("failed") ||
                                                    message.contains(
                                                      "Could not",
                                                    )
                                                ? Colors.red
                                                : Colors.green,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    TextFormField(
                                      controller: _amountCtrl,
                                      keyboardType: TextInputType.number,
                                      decoration: _inputDecoration(
                                        labelText: "Amount",
                                        hintText: "1000.00",
                                        icon: Icons.money,
                                      ),
                                      validator: (value) =>
                                          value == null || value.isEmpty
                                          ? "Amount required"
                                          : null,
                                    ),
                                    const SizedBox(height: 20),
                                    TextFormField(
                                      controller: _emailCtrl,
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: _inputDecoration(
                                        labelText: "Email",
                                        hintText: "example@gmail.com",
                                        icon: Icons.email,
                                      ),
                                      validator: (value) =>
                                          value == null || value.isEmpty
                                          ? "Email required"
                                          : null,
                                    ),
                                    const SizedBox(height: 40),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor: const Color(
                                          0xFF0D47A1,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 16,
                                        ),
                                        minimumSize: const Size(
                                          double.infinity,
                                          50,
                                        ),
                                        elevation: 5,
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
                                      child: const Text(
                                        "Pay Now",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          const Align(
                            alignment: Alignment.center,
                            child: AnimationService(
                              type: AnimationType.slide,
                              duration: Duration(seconds: 5),
                              curve: Curves.easeIn,
                              slideDirection: SlideDirection.left,

                              child: Text(
                                "Powered by DhayveScript Solutions",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String labelText,
    required String hintText,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      prefixIcon: Icon(icon, color: const Color(0xFF0D47A1)),
      labelStyle: const TextStyle(color: Colors.black54),
      hintStyle: const TextStyle(color: Colors.grey),
      filled: true,
      fillColor: Colors.grey[200],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF0D47A1), width: 2),
      ),
    );
  }
}

class BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF0D47A1), Color(0xFF1976D2)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    final circlePaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width * 0.9, size.height * 0.1),
      50,
      circlePaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.2, size.height * 0.8),
      100,
      circlePaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.5),
      75,
      circlePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
