import 'package:flutter/material.dart';
import 'package:waitless_mobile/src/config/app_localizations.dart';
import 'package:waitless_mobile/src/presentation/widgets/shared/pin_pad.dart';
import 'package:waitless_mobile/src/utils/constants/app_colors.dart';
import 'live_queue_page.dart';

class PinEntryPage extends StatefulWidget {

  const PinEntryPage({super.key});

  @override
  State<PinEntryPage> createState() => _PinEntryPageState();
}

class _PinEntryPageState extends State<PinEntryPage> {
  static const _correctPin = '1234'; // placeholder until real auth exists
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
    // Small delay so the 4th dot visibly fills before we react —
    // otherwise the transition feels instant/jarring.
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
      backgroundColor: AppColors.paper,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                l10n.hi,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _showError ? l10n.incorrectPin : l10n.enterPin,
                style: TextStyle(
                  fontSize: 13,
                  color: _showError ? AppColors.rust : AppColors.muted,
                ),
              ),
              const SizedBox(height: 28),

              // The dots: filled once a digit has been entered for that
              // position, empty otherwise.
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (i) {
                  final filled = i < _enteredPin.length;
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 7),
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: filled ? AppColors.ink : Colors.transparent,
                      border: Border.all(color: AppColors.ink, width: 1.5),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 32),

              PinPad(onDigit: _onDigit, onBackspace: _onBackspace),

              const SizedBox(height: 22),
            ],
          ),
        ),
      ),
    );
  }
}
