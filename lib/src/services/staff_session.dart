import 'package:waitless_mobile/src/exceptions/failure.dart';

/// Who is on the floor right now: the venue this device is watching and the
/// waitress who unlocked it with her PIN. Held in memory only — closing the app
/// sends you back to the PIN screen, which is the behaviour you want on a
/// device that gets passed around a restaurant.
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
          message: 'No venue selected', statusCode: '400');
    }
    return id;
  }

  /// The backend records who took each request, so acknowledging needs an identity.
  String requireStaffId() {
    final id = staffId;
    if (id == null) {
      throw const ApiFailure(
          message: 'Enter your PIN first', statusCode: '400');
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
