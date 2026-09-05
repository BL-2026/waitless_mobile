import 'package:flutter/material.dart';
import 'package:waitless_mobile/src/utils/constants/app_colors.dart';

class CustomLoadingIndicator extends StatelessWidget {
  final String text;

  const CustomLoadingIndicator({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          width: 28,
          height: 28,
          child: CircularProgressIndicator(
            color: AppColors.espresso,
            strokeWidth: 2.4,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          text,
          style: const TextStyle(color: AppColors.muted, fontSize: 13),
        ),
      ],
    );
  }
}
