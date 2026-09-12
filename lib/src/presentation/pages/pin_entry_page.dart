import 'package:flutter/material.dart';
import 'package:waitless_mobile/src/config/app_localizations.dart';
import 'package:waitless_mobile/src/data/sources/network/staff/staff_remote_data_source.dart';
import 'package:waitless_mobile/src/data/sources/network/store/store_remote_data_source.dart';
import 'package:waitless_mobile/src/domain/entities/staff_member.dart';
import 'package:waitless_mobile/src/exceptions/failure.dart';
import 'package:waitless_mobile/src/presentation/widgets/shared/brand_mark.dart';
import 'package:waitless_mobile/src/presentation/widgets/shared/pin_pad.dart';
import 'package:waitless_mobile/src/presentation/widgets/shared/primary_button.dart';
import 'package:waitless_mobile/src/presentation/widgets/shared/spinners/custom_loading_indicator.dart';
import 'package:waitless_mobile/src/services/injection_container.dart';
import 'package:waitless_mobile/src/services/staff_session.dart';
import 'package:waitless_mobile/src/utils/constants/app_colors.dart';
import 'package:waitless_mobile/src/utils/theme/app_theme.dart';
import 'live_queue_page.dart';

class PinEntryPage extends StatefulWidget {
  const PinEntryPage({super.key});

  @override
  State<PinEntryPage> createState() => _PinEntryPageState();
}

class _PinEntryPageState extends State<PinEntryPage> {
  final _session = sl<StaffSession>();

  List<StaffMember> _staff = const [];
  StaffMember? _selected;
  String _enteredPin = '';
  bool _loading = true;
  bool _verifying = false;
  bool _showError = false;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    _load();
  }

  /// Resolves the venue this device belongs to, then who can unlock it.
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
        _staff = staff;
        _selected = staff.length == 1 ? staff.first : null;
        _loading = false;
        _loadError = staff.isEmpty ? context.l10n.noStaffYet : null;
      });
    } on Failure catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _loadError = e.message;
      });
    }
  }

  void _onDigit(String digit) {
    if (_enteredPin.length >= 4 || _verifying || _selected == null) return;

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

  Future<void> _checkPin() async {
    final staff = _selected;
    if (staff == null) return;

    setState(() => _verifying = true);
    try {
      // The PIN never leaves the server as plaintext beyond this call; it is
      // compared against a bcrypt hash there, not here.
      final verified =
          await sl<StaffRemoteDataSource>().verifyPin(staff.id, _enteredPin);

      if (!mounted) return;
      if (verified == null) {
        setState(() {
          _verifying = false;
          _showError = true;
          _enteredPin = '';
        });
        return;
      }

      _session
        ..staffId = verified.id
        ..staffName = verified.fullName;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LiveQueuePage()),
      );
    } on Failure catch (e) {
      if (!mounted) return;
      setState(() {
        _verifying = false;
        _showError = true;
        _enteredPin = '';
        _loadError = e.message;
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
          child: _loading
              ? CustomLoadingIndicator(text: l10n.loading)
              : _loadError != null && _staff.isEmpty
                  ? _ErrorView(message: _loadError!, onRetry: _load)
                  : _buildPinEntry(l10n),
        ),
      ),
    );
  }

  Widget _buildPinEntry(AppLocalizations l10n) {
    return Column(
      children: [
        const SizedBox(height: 28),
        const BrandMark(compact: true),
        const Spacer(),
        Text(_session.storeName ?? l10n.pinUnlock, style: AppTheme.display(28)),
        const SizedBox(height: 16),
        _StaffPicker(
          staff: _staff,
          selected: _selected,
          label: l10n.chooseStaff,
          onSelect: (member) => setState(() {
            _selected = member;
            _enteredPin = '';
            _showError = false;
          }),
        ),
        const SizedBox(height: 20),
        Text(
          _showError
              ? (_loadError ?? l10n.incorrectPin)
              : _selected == null
                  ? l10n.chooseStaff
                  : l10n.enterPin,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: _showError ? AppColors.clay : AppColors.muted,
          ),
        ),
        const SizedBox(height: 20),
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
        const SizedBox(height: 24),
        Opacity(
          opacity: _selected == null ? 0.4 : 1,
          child: PinPad(onDigit: _onDigit, onBackspace: _onBackspace),
        ),
        const Spacer(),
      ],
    );
  }
}

class _StaffPicker extends StatelessWidget {
  const _StaffPicker({
    required this.staff,
    required this.selected,
    required this.label,
    required this.onSelect,
  });

  final List<StaffMember> staff;
  final StaffMember? selected;
  final String label;
  final ValueChanged<StaffMember> onSelect;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: staff.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final member = staff[index];
          final isSelected = member.id == selected?.id;
          return ChoiceChip(
            label: Text(member.fullName),
            selected: isSelected,
            onSelected: (_) => onSelect(member),
            showCheckmark: false,
            selectedColor: AppColors.espresso,
            backgroundColor: AppColors.surface,
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : AppColors.espresso,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
            side: BorderSide(
                color: isSelected ? AppColors.espresso : AppColors.line),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)),
          );
        },
      ),
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
          const SizedBox(height: 24),
          PrimaryButton(label: l10n.retry, onPressed: onRetry),
        ],
      ),
    );
  }
}
