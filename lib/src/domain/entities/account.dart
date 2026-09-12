/// Mirrors `AccountResponse` on the backend — the owner account stored in Postgres,
/// keyed by the Firebase UID. Returned by `POST /api/account` and `GET /api/account/me`.
class Account {
  final String id;
  final String firebaseUid;
  final String? fullName;
  final String? phoneArea;
  final String? phoneNumber;
  final String? email;
  final DateTime? createdAt;

  const Account({
    required this.id,
    required this.firebaseUid,
    this.fullName,
    this.phoneArea,
    this.phoneNumber,
    this.email,
    this.createdAt,
  });

  /// The number as the user typed it, dial code included: `+212612345678`.
  String? get fullPhoneNumber =>
      phoneNumber == null ? null : '${phoneArea ?? ''}$phoneNumber';

  factory Account.fromJson(Map<String, dynamic> json) => Account(
        id: json['id'].toString(),
        firebaseUid: json['firebaseUid'].toString(),
        fullName: json['fullName']?.toString(),
        phoneArea: json['phoneArea']?.toString(),
        phoneNumber: json['phoneNumber']?.toString(),
        email: json['email']?.toString(),
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt'].toString()),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'firebaseUid': firebaseUid,
        'fullName': fullName,
        'phoneArea': phoneArea,
        'phoneNumber': phoneNumber,
        'email': email,
        'createdAt': createdAt?.toIso8601String(),
      };

  @override
  String toString() => 'Account(id: $id, email: $email)';
}

/// Body for `POST /api/account`. Every field is optional: the backend falls back to
/// the verified Firebase token for [fullName] and [email] when they are blank.
class CreateAccountRequest {
  final String? fullName;
  final String? phoneArea;
  final String? phoneNumber;
  final String? email;

  const CreateAccountRequest({
    this.fullName,
    this.phoneArea,
    this.phoneNumber,
    this.email,
  });

  Map<String, dynamic> toJson() => {
        'fullName': fullName,
        'phoneArea': phoneArea,
        'phoneNumber': phoneNumber,
        'email': email,
      };
}
