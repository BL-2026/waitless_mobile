import 'package:flutter/material.dart';
import 'package:waitless_mobile/src/config/app_localizations.dart';
import 'package:waitless_mobile/src/utils/constants/app_colors.dart';
import 'package:waitless_mobile/src/utils/theme/app_theme.dart';

class EmptyQueueView extends StatelessWidget {
  const EmptyQueueView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.surface,
                border: Border.all(color: AppColors.line),
              ),
              child: const Icon(
                Icons.check_rounded,
                color: AppColors.sage,
                size: 32,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.allCaughtUp,
              textAlign: TextAlign.center,
              style: AppTheme.display(26),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.emptyQueueHint,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.muted,
                fontSize: 14,
                height: 1.45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
