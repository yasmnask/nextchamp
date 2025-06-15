import '../services/chat_service.dart';

class ChatSessionManager {
  final ChatService _chatService;
  String? _currentSessionId;

  ChatSessionManager(this._chatService);

  Future<String> getOrCreateSession(String? userId) async {
    try {
      // Return existing session if available and valid (not temporary)
      if (_currentSessionId != null &&
          _currentSessionId!.isNotEmpty &&
          !_currentSessionId!.startsWith('temp_')) {
        return _currentSessionId!;
      }

      // Try to get existing user sessions first (if userId is provided)
      if (userId != null && userId.isNotEmpty) {
        try {
          final sessions = await _chatService.getUserSessions(userId);
          if (sessions.isNotEmpty) {
            _currentSessionId = sessions.first.id;
            return _currentSessionId!;
          }
        } catch (e) {
          print('⚠️ Error getting user sessions: $e');
          // Continue to create new session
        }
      }

      // Create new session
      try {
        final session = await _chatService.createChatSession(
          userId: userId,
          title: userId != null ? 'ChampBot Chat Session' : 'Anonymous Chat',
        );

        _currentSessionId = session.id;
        return _currentSessionId!;
      } catch (createError) {
        print('❌ Failed to create session: $createError');

        // Last resort: create temporary session ID for offline mode
        _currentSessionId = 'temp_${DateTime.now().millisecondsSinceEpoch}';

        return _currentSessionId!;
      }
    } catch (e) {
      print('❌ Error in getOrCreateSession: $e');

      // Fallback: create temporary session ID
      _currentSessionId = 'temp_${DateTime.now().millisecondsSinceEpoch}';

      return _currentSessionId!;
    }
  }

  // Method to clear current session
  void clearCurrentSession() {
    _currentSessionId = null;
  }

  // Method to get current session ID
  String? getCurrentSessionId() {
    return _currentSessionId;
  }

  // Method to check if current session is temporary
  bool isTemporarySession() {
    return _currentSessionId?.startsWith('temp_') ?? false;
  }
}
