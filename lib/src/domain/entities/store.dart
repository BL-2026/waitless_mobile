/// Mirrors `StoreResponse` on the backend.
class Store {
  final String id;
  final String name;

  const Store({required this.id, required this.name});

  factory Store.fromJson(Map<String, dynamic> json) => Store(
        id: json['id'].toString(),
        name: json['name'].toString(),
      );
}
