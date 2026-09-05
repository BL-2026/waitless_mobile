import 'package:flutter/material.dart';

class CustomLoadingIndicator extends StatelessWidget {
  final String text;

  const CustomLoadingIndicator({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(
          color: Colors.redAccent,
        ),
        const SizedBox(height: 16),
        Text(text),
      ],
    );
  }
}
