import 'package:flutter/material.dart';
import 'package:waitless_mobile/src/config/app_localizations.dart';
import 'package:waitless_mobile/src/domain/entities/request_status.dart';
import 'package:waitless_mobile/src/domain/entities/request_type.dart';
import 'package:waitless_mobile/src/domain/entities/service_request.dart';
import 'package:waitless_mobile/src/utils/constants/app_colors.dart';

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

  Color get _accentColor {
    switch (request.status) {
      case RequestStatus.open:
        return AppColors.rust;
      case RequestStatus.acknowledged:
        return AppColors.brass;
      case RequestStatus.resolved:
        return AppColors.teal;
    }
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
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border(left: BorderSide(color: _accentColor, width: 3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.table(request.tableNumber),
                style: const TextStyle(
                  color: AppColors.paper,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              Text(
                _timeLabel(l10n),
                style: const TextStyle(color: Color(0xFF6B6858), fontSize: 10.5),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            _typeLabel(l10n),
            style: const TextStyle(color: Color(0xFFCFCABB), fontSize: 12),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              // Once acknowledged, there's no need to show "Acknowledge"
              // again — only "Resolve" remains.
              if (request.status == RequestStatus.open)
                Expanded(
                  child: _ActionButton(
                    label: l10n.acknowledge,
                    background: const Color(0xFF2A2B27),
                    textColor: AppColors.paper,
                    onTap: onAcknowledge,
                  ),
                ),
              if (request.status == RequestStatus.open) const SizedBox(width: 6),
              Expanded(
                child: _ActionButton(
                  label: l10n.resolve,
                  background: AppColors.teal,
                  textColor: const Color(0xFF0D1F1A),
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
  final Color background;
  final Color textColor;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.background,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(6),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(6),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: textColor,
            fontSize: 10.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
