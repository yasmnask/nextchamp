import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../core/dio_client.dart';
import '../models/chat_model.dart';
import '../utils/strapi_query_builder.dart';

class ChatService {
  final _dio = DioClient().dio;

  Future<ChatSession> createChatSession({
    String? userId,
    String? courseId,
    String? title,
  }) async {
    try {
      final Map<String, dynamic> dataContent = {
        'title': title ?? 'New Chat',
        'started_at': DateTime.now().toIso8601String(),
        'last_activity': DateTime.now().toIso8601String(),
      };

      // Add user ID if provided and valid
      if (userId != null && userId.isNotEmpty) {
        final userIdInt = int.tryParse(userId);
        if (userIdInt != null) {
          dataContent['user'] = userIdInt;
        } else {
          print('⚠️ Invalid user ID format: $userId');
        }
      }

      // Add course ID if provided and valid
      if (courseId != null && courseId.isNotEmpty) {
        final courseIdInt = int.tryParse(courseId);
        if (courseIdInt != null) {
          dataContent['course'] = courseIdInt;
        }
      }

      final Map<String, dynamic> requestData = {'data': dataContent};

      final response = await _dio.post(
        '/chat-sessions',
        data: requestData,
        options: Options(
          headers: {'Content-Type': 'application/json'},
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(
          'Failed to create session: HTTP ${response.statusCode}',
        );
      }

      if (response.data == null || response.data['data'] == null) {
        throw Exception('Invalid response structure from server');
      }

      final session = ChatSession.fromJson(response.data['data']);
      return session;
    } on DioException catch (e) {
      print('❌ DioException in createChatSession:');
      if (e.response != null) {
        print('Status: ${e.response?.statusCode}');
        print('Data: ${e.response?.data}');
        print('Headers: ${e.response?.headers}');
        print('Request: ${e.response?.requestOptions.data}');
      }
      throw Exception('Network error creating chat session: ${e.message}');
    } catch (e) {
      print('❌ Unexpected error in createChatSession: $e');
      throw Exception('Failed to create chat session: $e');
    }
  }

  Future<List<ChatMessage>> getMessages(String sessionId) async {
    try {
      // Don't try to get messages for temporary sessions
      if (sessionId.startsWith('temp_')) {
        print('⚠️ Skipping message retrieval for temporary session');
        return [];
      }

      final sessionIdInt = int.tryParse(sessionId);
      final filterValue = sessionIdInt?.toString() ?? sessionId;

      final query = StrapiQueryBuilder()
          .filter('chat_session.id', filterValue)
          .sortBy('timestamp')
          .populateField('chat_session')
          .build();

      final response = await _dio.get(
        '/chat-messages',
        queryParameters: Uri.splitQueryString(query),
      );

      if (response.data == null || response.data['data'] == null) {
        return [];
      }

      final messages = (response.data['data'] as List)
          .map((msg) => ChatMessage.fromJson(msg))
          .toList();

      return messages;
    } catch (e) {
      print('❌ Error loading messages: $e');
      return []; // Return empty list instead of throwing
    }
  }

  Future<ChatMessage> saveMessage({
    required String sessionId,
    required String content,
    required bool isFromBot,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      // Don't try to save messages for temporary sessions
      if (sessionId.startsWith('temp_')) {
        // Return a mock ChatMessage
        return ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          sessionId: sessionId,
          content: content,
          isFromBot: isFromBot,
          timestamp: DateTime.now(),
          metadata: metadata,
        );
      }

      // Validate inputs
      if (sessionId.isEmpty) {
        throw Exception('Session ID cannot be empty');
      }

      if (content.trim().isEmpty) {
        throw Exception('Message content cannot be empty');
      }

      // Try to parse session ID as integer for Strapi
      final sessionIdInt = int.tryParse(sessionId);
      if (sessionIdInt == null) {
        throw Exception('Invalid session ID format: $sessionId');
      }

      // Prepare the payload according to Strapi v4 format
      final Map<String, dynamic> dataContent = {
        'content': content.trim(),
        'is_from_bot': isFromBot,
        'timestamp': DateTime.now().toIso8601String(),
        'chat_session': sessionIdInt,
      };

      // Add metadata if provided
      if (metadata != null && metadata.isNotEmpty) {
        dataContent['metadata'] = metadata;
      }

      final Map<String, dynamic> requestData = {'data': dataContent};

      final response = await _dio.post(
        '/chat-messages',
        data: requestData,
        options: Options(
          headers: {'Content-Type': 'application/json'},
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 400) {
        String errorMessage = 'Bad Request';
        if (response.data is Map && response.data['error'] != null) {
          if (response.data['error']['message'] != null) {
            errorMessage = response.data['error']['message'];
          }
        }
        throw Exception('Failed to save message: $errorMessage');
      }

      if (response.statusCode! >= 400) {
        throw Exception('HTTP ${response.statusCode}: ${response.data}');
      }

      // FIXED: Update last activity with correct endpoint
      try {
        final updateData = {
          'data': {'last_activity': DateTime.now().toIso8601String()},
        };

        // Use documentId if available, otherwise use regular ID
        String updateEndpoint;
        if (response.data['data'] != null &&
            response.data['data']['documentId'] != null) {
          // For Strapi v5, use documentId
          updateEndpoint =
              '/chat-sessions/${response.data['data']['documentId']}';
        } else {
          // For Strapi v4, use regular ID
          updateEndpoint = '/chat-sessions/$sessionIdInt';
        }

        final updateResponse = await _dio.put(
          updateEndpoint,
          data: updateData,
          options: Options(validateStatus: (status) => status! < 500),
        );

        if (updateResponse.statusCode == 200 ||
            updateResponse.statusCode == 201) {
        } else {
          print(
            '⚠️ Session update returned status: ${updateResponse.statusCode}',
          );
        }
      } catch (updateError) {
        print(
          '⚠️ Warning: Failed to update session last activity: $updateError',
        );
      }

      // Parse and return the saved message
      if (response.data != null && response.data['data'] != null) {
        return ChatMessage.fromJson(response.data['data']);
      } else {
        // Fallback: create a ChatMessage from our input data
        return ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          sessionId: sessionId,
          content: content,
          isFromBot: isFromBot,
          timestamp: DateTime.now(),
          metadata: metadata,
        );
      }
    } catch (e) {
      print('❌ Error in saveMessage: $e');
      throw Exception('Failed to save message: $e');
    }
  }

  Future<List<ChatSession>> getUserSessions(String userId) async {
    try {
      final query = StrapiQueryBuilder()
          .filter('user.id', userId)
          .sortBy('last_activity', desc: true)
          .build();

      final response = await _dio.get('/chat-sessions?$query');

      if (response.data == null || response.data['data'] == null) {
        return [];
      }

      final sessions = (response.data['data'] as List)
          .map((s) => ChatSession.fromJson(s))
          .toList();
      return sessions;
    } catch (e) {
      print('❌ Error getting user sessions: $e');
      return []; // Return empty list instead of throwing
    }
  }

  Future<List<ChatSession>> getInactiveSessions() async {
    try {
      final query = StrapiQueryBuilder()
          .filterDateRange(
            'last_activity',
            null,
            DateTime.now().subtract(Duration(days: 1)),
          )
          .build();

      final response = await _dio.get('/chat-sessions?$query');

      if (response.data == null || response.data['data'] == null) {
        return [];
      }

      return (response.data['data'] as List)
          .map((s) => ChatSession.fromJson(s))
          .toList();
    } catch (e) {
      print('Error getting inactive sessions: $e');
      return [];
    }
  }
}
