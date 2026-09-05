import 'package:flutter/material.dart';
import 'package:waitless_mobile/src/utils/constants/app_colors.dart';

class PinPad extends StatelessWidget {
  final ValueChanged<String> onDigit;
  final VoidCallback onBackspace;

  const PinPad({
    super.key,
    required this.onDigit,
    required this.onBackspace,
  });

  @override
  Widget build(BuildContext context) {
    const keys = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '', '0', '⌫'];

    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 14,
      crossAxisSpacing: 14,
      children: keys.map((key) {
        if (key.isEmpty) return const SizedBox.shrink();

        final isBackspace = key == '⌫';

        return InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: () => isBackspace ? onBackspace() : onDigit(key),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isBackspace ? Colors.transparent : Colors.white,
              border: isBackspace
                  ? null
                  : Border.all(color: const Color(0xFFE2DCCB)),
            ),
            alignment: Alignment.center,
            child: Text(
              key,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.ink,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
