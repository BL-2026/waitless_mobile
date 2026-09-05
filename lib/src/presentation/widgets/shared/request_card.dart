import 'package:flutter/material.dart';
import 'package:waitless_mobile/src/config/app_localizations.dart';
import 'package:waitless_mobile/src/domain/entities/request_status.dart';
import 'package:waitless_mobile/src/domain/entities/request_type.dart';
import 'package:waitless_mobile/src/domain/entities/service_request.dart';
import 'package:waitless_mobile/src/utils/constants/app_colors.dart';
import 'package:waitless_mobile/src/utils/theme/app_theme.dart';

class RequestCard extends StatelessWidget {
  final ServiceRequest request;
  final VoidCallback onAcknowledge;
  final VoidCallback onResolve;

  const RequestCard({
    super.key,
    required this.request,
    required this.onAcknowledge,
    required this.onResolve,
  });

  Color get _accent {
    final wait = DateTime.now().difference(request.createdAt);
    if (request.status == RequestStatus.acknowledged) return AppColors.sage;
    if (wait.inMinutes >= 3) return AppColors.clay;
    return AppColors.gold;
  }

  String _typeLabel(AppLocalizations l10n) {
    if (request.type == RequestType.callWaiter) return l10n.callWaiter;
    final method = request.paymentMethod;
    return method != null
        ? l10n.requestingBillWithMethod(method)
        : l10n.requestingBill;
  }

  String _timeLabel(AppLocalizations l10n) {
    final diff = DateTime.now().difference(request.createdAt);
    if (diff.inSeconds < 60) return l10n.justNow;
    if (diff.inMinutes < 60) return l10n.minutesAgo(diff.inMinutes);
    return l10n.hoursAgo(diff.inHours);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isOpen = request.status == RequestStatus.open;
    final waiting = request.status == RequestStatus.acknowledged;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.line),
        boxShadow: [
          BoxShadow(
            color: AppColors.espresso.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: _accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  l10n.zoneName(request.zone).toUpperCase(),
                  style: TextStyle(
                    color: _accent,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.1,
                  ),
                ),
              ),
              const Spacer(),
              Icon(Icons.schedule, size: 14, color: AppColors.muted),
              const SizedBox(width: 4),
              Text(
                _timeLabel(l10n),
                style: const TextStyle(color: AppColors.muted, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${request.tableNumber}',
                style: AppTheme.display(44),
              ),
              const SizedBox(width: 10),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  l10n.tableLabel,
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              Icon(
                request.type == RequestType.callWaiter
                    ? Icons.waving_hand_outlined
                    : Icons.receipt_long_outlined,
                color: AppColors.espresso,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            _typeLabel(l10n),
            style: const TextStyle(
              color: AppColors.espresso,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              if (isOpen)
                Expanded(
                  child: _ActionButton(
                    label: l10n.onMyWay,
                    filled: false,
                    onTap: onAcknowledge,
                  ),
                ),
              if (isOpen) const SizedBox(width: 8),
              Expanded(
                child: _ActionButton(
                  label: waiting ? l10n.done : l10n.resolve,
                  filled: true,
                  onTap: onResolve,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final bool filled;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.filled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          color: filled ? AppColors.espresso : AppColors.canvas,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: filled ? AppColors.espresso : AppColors.line,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: filled ? Colors.white : AppColors.espresso,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
