import 'package:flutter/material.dart';
import 'package:waitless_mobile/src/config/app_localizations.dart';
import 'package:waitless_mobile/src/utils/constants/app_colors.dart';

class EmptyQueueView extends StatelessWidget {
  const EmptyQueueView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF3A3B37), width: 1.5),
            ),
            child: const Icon(Icons.check, color: Color(0xFF6B6858), size: 22),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.allCaughtUp,
            style: const TextStyle(
              color: AppColors.paper,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.emptyQueueHint,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF6B6858), fontSize: 12),
          ),
        ],
      ),
    );
  }
}
