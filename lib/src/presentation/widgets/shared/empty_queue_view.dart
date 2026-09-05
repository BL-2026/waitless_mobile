import 'package:flutter/material.dart';
import 'package:waitless_mobile/src/utils/constants/app_colors.dart';

class EmptyQueueView extends StatelessWidget {
  const EmptyQueueView({super.key});

  @override
  Widget build(BuildContext context) {
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
          const Text(
            'All caught up',
            style: TextStyle(
              color: AppColors.paper,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'New requests from tables will appear here instantly.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF6B6858), fontSize: 12),
          ),
        ],
      ),
    );
  }
}
