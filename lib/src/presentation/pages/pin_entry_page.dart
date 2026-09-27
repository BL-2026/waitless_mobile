import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waitless_mobile/src/config/app_localizations.dart';
import 'package:waitless_mobile/src/utils/helpers/failure_messages.dart';
import 'package:waitless_mobile/src/data/sources/network/staff/staff_remote_data_source.dart';
import 'package:waitless_mobile/src/data/sources/network/store/store_remote_data_source.dart';
import 'package:waitless_mobile/src/exceptions/failure.dart';
import 'package:waitless_mobile/src/presentation/cubits/auth/logout/logout_cubit.dart';
import 'package:waitless_mobile/src/presentation/widgets/shared/brand_mark.dart';
import 'package:waitless_mobile/src/presentation/widgets/shared/pin_pad.dart';
import 'package:waitless_mobile/src/presentation/widgets/shared/primary_button.dart';
import 'package:waitless_mobile/src/presentation/widgets/shared/snackbars/custom_snack_bar.dart';
import 'package:waitless_mobile/src/presentation/widgets/shared/spinners/custom_loading_indicator.dart';
import 'package:waitless_mobile/src/services/injection_container.dart';
import 'package:waitless_mobile/src/services/push_notification_service.dart';
import 'package:waitless_mobile/src/services/staff_session.dart';
import 'package:waitless_mobile/src/utils/constants/app_colors.dart';
import 'package:waitless_mobile/src/utils/constants/strings.dart';
import 'package:waitless_mobile/src/utils/constants/urls.dart';
import 'package:waitless_mobile/src/utils/theme/app_theme.dart';
import 'live_queue_page.dart';

class PinEntryPage extends StatefulWidget {
  const PinEntryPage({super.key});

  @override
  State<PinEntryPage> createState() => _PinEntryPageState();
}

class _PinEntryPageState extends State<PinEntryPage> {
  final _session = sl<StaffSession>();

  String _enteredPin = '';
  bool _loading = true;
  bool _verifying = false;
  bool _hasStaff = false;
  String? _loadError;
  String? _pinError;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _loadError = null;
    });

    try {
      final stores = await sl<StoreRemoteDataSource>().listStores();
      if (stores.isEmpty) {
        if (!mounted) return;
        setState(() {
          _loading = false;
          _hasStaff = false;
          _loadError = context.l10n.noStoreYet;
        });
        return;
      }

      // One venue per owner for now; the first is the only one.
      _session
        ..storeId = stores.first.id
        ..storeName = stores.first.name;

      final staff = await sl<StaffRemoteDataSource>().listStaff(stores.first.id);
      if (!mounted) return;
      setState(() {
        _hasStaff = staff.isNotEmpty;
        _loading = false;
        _loadError = staff.isEmpty ? context.l10n.noStaffYet : null;
      });
    } on Failure catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _hasStaff = false;
        _loadError = context.l10n.messageFor(e);
      });
    }
  }

  void _onDigit(String digit) {
    if (_enteredPin.length >= 4 || _verifying) return;

    setState(() {
      _enteredPin += digit;
      _pinError = null;
    });

    if (_enteredPin.length == 4) {
      _checkPin();
    }
  }

  void _onBackspace() {
    if (_enteredPin.isEmpty || _verifying) return;
    setState(() {
      _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1);
      _pinError = null;
    });
  }

  Future<void> _checkPin() async {
    setState(() => _verifying = true);
    try {
      final verified = await sl<StaffRemoteDataSource>()
          .verifyPin(_session.requireStoreId(), _enteredPin);

      if (!mounted) return;
      if (verified == null) {
        setState(() {
          _verifying = false;
          _pinError = context.l10n.incorrectPin;
          _enteredPin = '';
        });
        return;
      }

      _session
        ..staffId = verified.id
        ..staffName = verified.fullName;

      try {
        await sl<PushNotificationService>().registerForCurrentStore();
      } on Failure {
        // The floor still works without push; the in-app banner covers the open app.
      }

      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LiveQueuePage()),
      );
    } on Failure catch (e) {
      if (!mounted) return;
      setState(() {
        _verifying = false;
        _pinError = context.l10n.messageFor(e);
        _enteredPin = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocListener<LogoutCubit, LogoutState>(
      listener: (context, state) {
        if (state is LogoutInProgress) {
          showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              backgroundColor: AppColors.surface,
              content: CustomLoadingIndicator(text: l10n.loading),
            ),
          );
        } else if (state is LogoutFailure) {
          if (Navigator.canPop(context)) Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            CustomSnackBar(
              color: AppColors.clay,
              message: context.l10n.messageFor(state.failure),
              iconData: Icons.error_outline,
            ),
          );
        } else if (state is LogoutSuccess) {
          if (Navigator.canPop(context)) Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            CustomSnackBar(
              color: AppColors.sage,
              message: l10n.loggedOut,
              iconData: Icons.check,
            ),
          );
          Navigator.pushReplacementNamed(context, routeNameLanguage);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.canvas,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: _loading
                ? CustomLoadingIndicator(text: l10n.loading)
                : !_hasStaff
                    ? _ErrorView(
                        message: _loadError ?? l10n.noStaffYet,
                        onRetry: _load,
                      )
                    : _buildPinEntry(l10n),
          ),
        ),
      ),
    );
  }

  Widget _buildPinEntry(AppLocalizations l10n) {
    final hasError = _pinError != null;
    return Column(
      children: [
        const SizedBox(height: 28),
        const BrandMark(compact: true),
        const Spacer(),
        Text(_session.storeName ?? l10n.pinUnlock, style: AppTheme.display(28)),
        const SizedBox(height: 12),
        Text(
          hasError ? _pinError! : l10n.enterPin,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: hasError ? AppColors.clay : AppColors.muted,
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(4, (i) {
            final filled = i < _enteredPin.length;
            final accent = hasError ? AppColors.clay : AppColors.espresso;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              margin: const EdgeInsets.symmetric(horizontal: 8),
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: filled ? accent : Colors.transparent,
                border: Border.all(color: accent, width: 1.5),
              ),
            );
          }),
        ),
        const SizedBox(height: 24),
        Opacity(
          opacity: _verifying ? 0.4 : 1,
          child: PinPad(onDigit: _onDigit, onBackspace: _onBackspace),
        ),
        const Spacer(),
      ],
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.cloud_off_rounded,
              size: 40, color: AppColors.muted),
          const SizedBox(height: 16),
          Text(message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.muted, fontSize: 14)),
          const SizedBox(height: 12),
          Text(
            waitlessApiBaseUrl,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 11,
              fontFamily: 'Courier',
            ),
          ),
          const SizedBox(height: 24),
          PrimaryButton(label: l10n.retry, onPressed: onRetry),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: () => context.read<LogoutCubit>().logout(),
            icon: const Icon(Icons.logout_rounded, size: 18),
            label: Text(l10n.logout),
            style: TextButton.styleFrom(foregroundColor: AppColors.espresso),
          ),
        ],
      ),
    );
  }
}
