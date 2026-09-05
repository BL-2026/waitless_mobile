import 'package:flutter/material.dart';
import 'package:waitless_mobile/src/presentation/widgets/shared/brand_mark.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key, required this.subtitle});

  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const BrandMark(),
        const SizedBox(height: 12),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black.withValues(alpha: 0.5),
            fontSize: 15,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
