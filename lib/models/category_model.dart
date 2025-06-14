class CategoryModel {
  final int id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;

  CategoryModel({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    if (json['id'] != null && json['attributes'] != null) {
      final attributes = json['attributes'];
      return CategoryModel(
        id: json['id'],
        name: attributes['name'] ?? '',
        createdAt: DateTime.parse(
          attributes['createdAt'] ?? DateTime.now().toIso8601String(),
        ),
        updatedAt: DateTime.parse(
          attributes['updatedAt'] ?? DateTime.now().toIso8601String(),
        ),
      );
    }

    // Fallback for direct format
    return CategoryModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
