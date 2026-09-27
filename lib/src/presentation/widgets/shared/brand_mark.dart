import 'package:flutter/material.dart';
import 'package:waitless_mobile/src/utils/constants/app_colors.dart';
import 'package:waitless_mobile/src/utils/theme/app_theme.dart';

class BrandMark extends StatelessWidget {
  const BrandMark({
    super.key,
    this.compact = false,
    this.light = false,
  });

  final bool compact;
  final bool light;

  @override
  Widget build(BuildContext context) {
    final color = light ? Colors.white : AppColors.espresso;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: compact ? 8 : 10,
          height: compact ? 8 : 10,
          decoration: BoxDecoration(
            color: AppColors.gold,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(width: compact ? 8 : 10),
        Text(
          'Floor Call',
          style: AppTheme.display(compact ? 22 : 34).copyWith(color: color),
        ),
      ],
    );
  }
}
