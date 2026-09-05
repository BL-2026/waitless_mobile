import 'package:flutter/material.dart';
import 'package:waitless_mobile/src/utils/constants/app_colors.dart';

class CustomSnackBar extends SnackBar {
  CustomSnackBar({
    super.key,
    required String message,
    required IconData iconData,
    required Color color,
    super.duration = const Duration(seconds: 2),
  }) : super(
          content: Row(
            children: [
              Icon(iconData, color: Colors.white, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          backgroundColor: color,
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        );
}

class AppAlert extends StatelessWidget {
  const AppAlert({
    super.key,
    required this.title,
    required this.content,
    this.actionLabel,
  });

  final String title;
  final String content;
  final String? actionLabel;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
      content: Text(content),
      actions: [
        if (actionLabel != null)
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              actionLabel!,
              style: const TextStyle(color: AppColors.espresso),
            ),
          ),
      ],
    );
  }
}
