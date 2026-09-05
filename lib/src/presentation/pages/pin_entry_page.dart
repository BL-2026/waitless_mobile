import 'package:flutter/material.dart';
import 'package:waitless_mobile/src/config/app_localizations.dart';
import 'package:waitless_mobile/src/presentation/widgets/shared/brand_mark.dart';
import 'package:waitless_mobile/src/presentation/widgets/shared/pin_pad.dart';
import 'package:waitless_mobile/src/utils/constants/app_colors.dart';
import 'package:waitless_mobile/src/utils/theme/app_theme.dart';
import 'live_queue_page.dart';

class PinEntryPage extends StatefulWidget {
  const PinEntryPage({super.key});

  @override
  State<PinEntryPage> createState() => _PinEntryPageState();
}

class _PinEntryPageState extends State<PinEntryPage> {
  static const _correctPin = '1234';
  String _enteredPin = '';
  bool _showError = false;

  void _onDigit(String digit) {
    if (_enteredPin.length >= 4) return;

    setState(() {
      _enteredPin += digit;
      _showError = false;
    });

    if (_enteredPin.length == 4) {
      _checkPin();
    }
  }

  void _onBackspace() {
    if (_enteredPin.isEmpty) return;
    setState(() {
      _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1);
    });
  }

  void _checkPin() async {
    await Future.delayed(const Duration(milliseconds: 150));

    if (_enteredPin == _correctPin) {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LiveQueuePage()),
      );
    } else {
      setState(() {
        _showError = true;
        _enteredPin = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const SizedBox(height: 28),
              const BrandMark(compact: true),
              const Spacer(),
              Text(l10n.pinUnlock, style: AppTheme.display(28)),
              const SizedBox(height: 8),
              Text(
                _showError ? l10n.incorrectPin : l10n.enterPin,
                style: TextStyle(
                  fontSize: 14,
                  color: _showError ? AppColors.clay : AppColors.muted,
                ),
              ),
              const SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (i) {
                  final filled = i < _enteredPin.length;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 120),
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: filled ? AppColors.espresso : Colors.transparent,
                      border: Border.all(color: AppColors.espresso, width: 1.5),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 28),
              PinPad(onDigit: _onDigit, onBackspace: _onBackspace),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
