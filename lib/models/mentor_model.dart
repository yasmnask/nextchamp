class Mentor {
  final int id;
  final String name;
  final String description;
  final String? profileUrl;
  final bool isFeatured;
  final int? categoryId;
  final String? categoryName;
  final DateTime createdAt;
  final DateTime updatedAt;

  Mentor({
    required this.id,
    required this.name,
    required this.description,
    this.profileUrl,
    required this.isFeatured,
    this.categoryId,
    this.categoryName,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Mentor.fromJson(Map<String, dynamic> json) {
    // Handle Strapi v4 format with data and attributes
    if (json['id'] != null && json['attributes'] != null) {
      final attributes = json['attributes'];

      // Parse profile image URL from Strapi v4 media field
      String? profileUrl;
      final profileData = attributes['profile'];
      if (profileData != null) {
        if (profileData['data'] != null &&
            profileData['data']['attributes'] != null) {
          final profileAttributes = profileData['data']['attributes'];
          profileUrl = profileAttributes['url'];
        }
      }

      return Mentor(
        id: json['id'],
        name: attributes['name'] ?? '',
        description: attributes['description'] ?? '',
        profileUrl: profileUrl,
        isFeatured: attributes['is_featured'] ?? false,
        categoryId: attributes['category']?['data']?['id'],
        categoryName: attributes['category']?['data']?['attributes']?['name'],
        createdAt: DateTime.parse(
          attributes['createdAt'] ?? DateTime.now().toIso8601String(),
        ),
        updatedAt: DateTime.parse(
          attributes['updatedAt'] ?? DateTime.now().toIso8601String(),
        ),
      );
    }

    // Fallback for direct format
    return Mentor(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      profileUrl: json['profile']?['url'],
      isFeatured: json['is_featured'] ?? false,
      categoryId: json['category']?['id'],
      categoryName: json['category']?['name'],
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
      'description': description,
      'profileUrl': profileUrl,
      'isFeatured': isFeatured,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
