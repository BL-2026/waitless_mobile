import 'package:flutter/material.dart';
import 'package:waitless_mobile/src/utils/constants/app_colors.dart';

Widget buildHeader() {
  return Column(
    children: [
      Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [AppColors.ink, AppColors.teal],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ).createShader(bounds),
          child: const Text(
            'Waitless',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 1.1,
            ),
          ),
        ),
      ),
      const SizedBox(height: 20),
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.ink),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Image.asset(
          'assets/images/auth_logo.png',
          height: 180,
          fit: BoxFit.cover,
        ),
      ),
    ],
  );
}