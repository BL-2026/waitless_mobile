import 'package:waitless_mobile/src/exceptions/app_error_code.dart';
import 'package:waitless_mobile/src/exceptions/failure.dart';

class StaffSession {
  String? storeId;
  String? storeName;
  String? staffId;
  String? staffName;

  bool get isUnlocked => storeId != null && staffId != null;

  String requireStoreId() {
    final id = storeId;
    if (id == null) {
      throw const ApiFailure(
        message: 'No venue selected',
        statusCode: '400',
        code: AppErrorCode.noVenueSelected,
      );
    }
    return id;
  }

  /// The backend records who took each request, so acknowledging needs an identity.
  String requireStaffId() {
    final id = staffId;
    if (id == null) {
      throw const ApiFailure(
        message: 'Enter your PIN first',
        statusCode: '400',
        code: AppErrorCode.staffPinRequired,
      );
    }
    return id;
  }

  void endShift() {
    staffId = null;
    staffName = null;
  }

  void clear() {
    storeId = null;
    storeName = null;
    staffId = null;
    staffName = null;
  }
}
