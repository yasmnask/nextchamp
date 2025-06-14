class Course {
  final int id;
  final String title;
  final String description;
  final String? iconUrl;
  final bool isFree;
  final int? categoryId;
  final String? categoryName;
  final DateTime createdAt;
  final DateTime updatedAt;

  Course({
    required this.id,
    required this.title,
    required this.description,
    this.iconUrl,
    required this.isFree,
    this.categoryId,
    this.categoryName,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    // Handle Strapi v4 format with data and attributes
    if (json['id'] != null && json['attributes'] != null) {
      final attributes = json['attributes'];

      // FIXED: Better icon URL parsing for Strapi v4 media field
      String? iconUrl;
      final iconData = attributes['icon'];
      if (iconData != null) {
        if (iconData['data'] != null &&
            iconData['data']['attributes'] != null) {
          final iconAttributes = iconData['data']['attributes'];
          iconUrl = iconAttributes['url'];
        }
      }

      return Course(
        id: json['id'],
        title: attributes['title'] ?? '',
        description: attributes['description'] ?? '',
        iconUrl: iconUrl, // Use the properly parsed icon URL
        isFree: attributes['is_free'] ?? true,
        categoryId: attributes['category']?['data']?['id'],
        categoryName:
            attributes['category']?['data']?['attributes']?['title'] ??
            attributes['category']?['data']?['attributes']?['name'],
        createdAt: DateTime.parse(
          attributes['createdAt'] ?? DateTime.now().toIso8601String(),
        ),
        updatedAt: DateTime.parse(
          attributes['updatedAt'] ?? DateTime.now().toIso8601String(),
        ),
      );
    }

    // Fallback for direct format
    return Course(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      iconUrl: json['icon']?['url'],
      isFree: json['is_free'] ?? true,
      categoryId: json['category']?['id'],
      categoryName: json['category']?['title'] ?? json['category']?['name'],
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
      'title': title,
      'description': description,
      'iconUrl': iconUrl,
      'isFree': isFree,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
