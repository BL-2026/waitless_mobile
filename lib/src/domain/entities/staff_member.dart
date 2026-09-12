/// Mirrors `StaffResponse` on the backend. The PIN hash is never sent to the client.
class StaffMember {
  final String id;
  final String fullName;

  const StaffMember({required this.id, required this.fullName});

  factory StaffMember.fromJson(Map<String, dynamic> json) => StaffMember(
        id: json['id'].toString(),
        fullName: json['fullName'].toString(),
      );
}
