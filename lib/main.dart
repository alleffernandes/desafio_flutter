import 'package:desafio_orbytis/app/app.dart';
import 'package:flutter/material.dart';
import 'package:desafio_orbytis/core/di/service_locator.dart';

void main() {
  setupServiceLocator();
  runApp(const MainApp());
}
