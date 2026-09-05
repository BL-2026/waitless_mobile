import 'package:flutter/material.dart';
import 'package:waitless_mobile/src/utils/constants/app_colors.dart';

InputDecoration fieldDecoration({required String label, required Widget suffixIcon}) {
  return InputDecoration(
    labelText: label,
    labelStyle: const TextStyle(color: AppColors.muted),
    suffixIcon: suffixIcon,
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.ink),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.ink),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.ink, width: 1.5),
    ),
  );
}