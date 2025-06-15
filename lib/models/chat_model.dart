// models/chat_model.dart
class ChatSession {
  final String id;
  final String? title;
  final DateTime startedAt;
  final DateTime lastActivity;
  final String? userId;
  final String? courseId;

  ChatSession({
    required this.id,
    this.title,
    required this.startedAt,
    required this.lastActivity,
    this.userId,
    this.courseId,
  });

  factory ChatSession.fromJson(Map<String, dynamic> json) {
    try {
      print('🔍 Parsing ChatSession from JSON: $json');

      // Handle different possible JSON structures from Strapi
      Map<String, dynamic>? attributes;
      String? sessionId;

      // Check if this is a Strapi v4 response with attributes
      if (json['attributes'] != null) {
        attributes = json['attributes'] as Map<String, dynamic>;
        sessionId = json['id']?.toString();
      }
      // Check if this is a direct object (Strapi v3 style or direct data)
      else if (json['started_at'] != null || json['title'] != null) {
        attributes = json;
        sessionId = json['id']?.toString();
      }
      // Handle nested data structure
      else if (json['data'] != null) {
        if (json['data'] is Map) {
          attributes = json['data']['attributes'] ?? json['data'];
          sessionId = json['data']['id']?.toString();
        }
      }

      if (attributes == null || sessionId == null) {
        print('❌ Invalid JSON structure for ChatSession: $json');
        throw Exception('Invalid ChatSession JSON structure');
      }

      return ChatSession(
        id: sessionId,
        title: _safeStringConvert(attributes['title']),
        startedAt: _parseDateTime(attributes['started_at']) ?? DateTime.now(),
        lastActivity:
            _parseDateTime(attributes['last_activity']) ?? DateTime.now(),
        userId: _extractUserId(attributes['user']),
        courseId: _extractCourseId(attributes['course']),
      );
    } catch (e) {
      print('❌ Error parsing ChatSession: $e');
      print('❌ JSON was: $json');
      rethrow;
    }
  }

  // Helper method to safely parse DateTime
  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (e) {
        print('⚠️ Failed to parse datetime: $value');
        return null;
      }
    }
    return null;
  }

  // Helper method to safely convert any value to String
  static String? _safeStringConvert(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    return value.toString();
  }

  static String? _extractUserId(dynamic userData) {
    if (userData == null) return null;

    // Handle direct integer ID
    if (userData is int) {
      return userData.toString();
    }

    // Handle direct string ID
    if (userData is String) {
      return userData;
    }

    if (userData is Map<String, dynamic>) {
      // Case: user is a direct object with data
      if (userData['data'] != null) {
        if (userData['data'] is List && userData['data'].isNotEmpty) {
          return userData['data'][0]['id']?.toString();
        } else if (userData['data'] is Map) {
          return userData['data']['id']?.toString();
        }
      }
      // Case: user object has direct id
      if (userData['id'] != null) {
        return userData['id'].toString();
      }
    } else if (userData is List && userData.isNotEmpty) {
      // Case: user is an array
      if (userData[0] is Map && userData[0]['id'] != null) {
        return userData[0]['id']?.toString();
      } else {
        return userData[0]?.toString();
      }
    }

    return null;
  }

  static String? _extractCourseId(dynamic courseData) {
    if (courseData == null) return null;

    // Handle direct integer ID
    if (courseData is int) {
      return courseData.toString();
    }

    // Handle direct string ID
    if (courseData is String) {
      return courseData;
    }

    if (courseData is Map<String, dynamic>) {
      // Case: course is a direct object with data
      if (courseData['data'] != null) {
        if (courseData['data'] is List && courseData['data'].isNotEmpty) {
          return courseData['data'][0]['id']?.toString();
        } else if (courseData['data'] is Map) {
          return courseData['data']['id']?.toString();
        }
      }
      // Case: course object has direct id
      if (courseData['id'] != null) {
        return courseData['id'].toString();
      }
    } else if (courseData is List && courseData.isNotEmpty) {
      // Case: course is an array
      if (courseData[0] is Map && courseData[0]['id'] != null) {
        return courseData[0]['id']?.toString();
      } else {
        return courseData[0]?.toString();
      }
    }

    return null;
  }
}

class ChatMessage {
  final String id;
  final String sessionId;
  final String content;
  final bool isFromBot;
  final DateTime timestamp;
  final Map<String, dynamic>? metadata;

  ChatMessage({
    required this.id,
    required this.sessionId,
    required this.content,
    required this.isFromBot,
    required this.timestamp,
    this.metadata,
  });

  // FIXED: Improved JSON parsing with better error handling
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    try {
      print("🔍 Parsing ChatMessage from JSON: $json");

      // Handle both direct structure and nested attributes structure
      Map<String, dynamic>? attributes;
      String? messageId;

      // Check if this is a Strapi v4 response with attributes
      if (json['attributes'] != null) {
        attributes = json['attributes'] as Map<String, dynamic>;
        messageId = json['id']?.toString();
      }
      // Check if this is a direct object
      else if (json['content'] != null) {
        attributes = json;
        messageId = json['id']?.toString();
      }
      // Handle nested data structure
      else if (json['data'] != null) {
        if (json['data'] is Map) {
          attributes = json['data']['attributes'] ?? json['data'];
          messageId = json['data']['id']?.toString();
        }
      }

      if (attributes == null) {
        print('❌ Invalid JSON structure for ChatMessage: $json');
        throw Exception('Invalid ChatMessage JSON structure');
      }

      return ChatMessage(
        id: messageId ?? DateTime.now().millisecondsSinceEpoch.toString(),
        content: attributes['content']?.toString() ?? '',
        isFromBot: attributes['is_from_bot'] ?? false,
        timestamp: _parseDateTime(attributes['timestamp']) ?? DateTime.now(),
        sessionId: _extractSessionId(attributes['chat_session']),
        metadata: attributes['metadata'] as Map<String, dynamic>?,
      );
    } catch (e) {
      print('❌ Error parsing ChatMessage: $e');
      print('❌ JSON was: $json');
      rethrow;
    }
  }

  // Helper method to safely parse DateTime
  static DateTime _parseDateTime(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (e) {
        print('⚠️ Failed to parse datetime: $value');
        return DateTime.now();
      }
    }
    return DateTime.now();
  }

  // FIXED: Added proper session ID extraction
  static String _extractSessionId(dynamic sessionData) {
    if (sessionData == null) return '';

    if (sessionData is int) {
      return sessionData.toString();
    }

    if (sessionData is String) {
      return sessionData;
    }

    if (sessionData is Map<String, dynamic>) {
      if (sessionData['data'] != null) {
        if (sessionData['data'] is Map) {
          return sessionData['data']['id']?.toString() ?? '';
        }
      }
      return sessionData['id']?.toString() ?? '';
    }

    return '';
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'is_from_bot': isFromBot,
      'timestamp': timestamp.toIso8601String(),
      'metadata': metadata,
      'chat_session': int.tryParse(sessionId) ?? sessionId,
    };
  }
}
