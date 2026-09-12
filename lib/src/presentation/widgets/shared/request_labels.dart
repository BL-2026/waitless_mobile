import 'package:waitless_mobile/src/config/app_localizations.dart';
import 'package:waitless_mobile/src/domain/entities/request_type.dart';
import 'package:waitless_mobile/src/domain/entities/service_request.dart';

extension ServiceRequestLabels on ServiceRequest {
  /// "Call waiter", or "Requesting the bill · Cash" once the customer has said how
  /// they mean to pay. Shared by the queue card and the new-request alert so the
  /// two can't describe the same request differently.
  String typeLabel(AppLocalizations l10n) {
    if (type == RequestType.callWaiter) return l10n.callWaiter;
    final method = paymentMethod;
    return method != null
        ? l10n.requestingBillWithMethod(l10n.paymentMethodName(method))
        : l10n.requestingBill;
  }
}
