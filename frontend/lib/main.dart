import 'package:flutter/material.dart';
import 'package:frontend/app.dart';
import 'package:frontend/core/injector/injector.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  initInjector();

  runApp(const Transactions());
}
