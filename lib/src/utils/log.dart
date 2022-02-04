import 'package:flutter/material.dart';

bool isPrintLog = true;

void log(String message) {
  if (isPrintLog) {
    debugPrint(message);
  }
}
