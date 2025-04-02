import 'package:flutter/material.dart';

class Result {
  final bool isSuccess;
  final String message;
  final Color? color;

  Result({
    required this.isSuccess,
    required this.message,
    this.color
  });
}