import 'package:flutter/material.dart';
import 'package:product_task/core/dependencies/injection_container.dart';
import 'package:product_task/core/initialize_app/my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencies();
  runApp(const MyApp());
}
