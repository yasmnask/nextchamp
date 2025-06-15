import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:nextchamp/services/chat_session_manager.dart';
import 'package:provider/provider.dart';
import '../models/chat_model.dart';
import '../services/chat_service.dart';
import '../services/gemini_service.dart';
import '../providers/user_provider.dart';

class ChampbotPage extends StatefulWidget {
  @override
  _ChampbotPageState createState() => _ChampbotPageState();
}

class _ChampbotPageState extends State<ChampbotPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late ChatService _chatService;
  late GeminiService _geminiService;
  late final ChatSessionManager _sessionManager;

  String? _currentSessionId;
  List<ChatMessage> messages = [];
  bool _isLoading = false;
  bool _isBotTyping = false;

  @override
  void initState() {
    super.initState();
    _chatService = ChatService();
    _geminiService = GeminiService();
    _sessionManager = ChatSessionManager(_chatService);
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    if (!mounted) return;

    try {
      setState(() => _isLoading = true);

      // FIXED: Proper context usage
      final userId = context.read<UserProvider>().user?.id?.toString();

      _currentSessionId = await _sessionManager.getOrCreateSession(userId);

      if (_currentSessionId != null) {
        final history = await _chatService.getMessages(_currentSessionId!);

        if (mounted) {
          setState(() {
            messages = history;
            _isLoading = false;
          });

          if (history.isEmpty) {
            await _sendWelcomeMessage();
          }
          _scrollToBottom();
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading chat: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _sendWelcomeMessage() async {
    if (!mounted || _currentSessionId == null) return;

    try {
      final userProvider = context.read<UserProvider>();
      final userName = userProvider.user?.username ?? 'there';

      final welcomeMessage = ChatMessage(
        id: 'welcome-${DateTime.now().millisecondsSinceEpoch}',
        content:
            "Hai $userName! Ada yang bisa saya bantu terkait kursus atau pembelajaran?",
        isFromBot: true,
        timestamp: DateTime.now(),
        sessionId: _currentSessionId!,
      );

      if (mounted) {
        setState(() {
          messages.add(welcomeMessage);
        });
      }

      // Save to backend
      await _chatService.saveMessage(
        sessionId: _currentSessionId!,
        content: welcomeMessage.content,
        isFromBot: true,
      );

      _scrollToBottom();
    } catch (e) {
      print('Error sending welcome message: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Champ Bot',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: const Color(0xFF2C3E50),
        elevation: 0,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 18,
              child: ClipOval(
                child: Image.asset(
                  'assets/kepala_bot.png',
                  width: 32,
                  height: 32,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.smart_toy,
                      color: Color(0xFF475569),
                      size: 20,
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              color: Colors.white,
              child: Stack(
                children: [
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.15,
                    left: MediaQuery.of(context).size.width * 0.1,
                    right: MediaQuery.of(context).size.width * 0.1,
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: Image.asset(
                      'assets/gradasi_bg_bot.png',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFFFFFBF0), Color(0xFFF0F9FF)],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          controller: _scrollController,
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          itemCount: messages.length + (_isBotTyping ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (_isBotTyping && index == messages.length) {
                              return _buildTypingIndicator();
                            }
                            return _buildChatBubble(messages[index]);
                          },
                        ),
                      ),
                      _buildInputArea(),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: 32,
            height: 32,
            margin: EdgeInsets.only(right: 8, bottom: 4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/kepala_bot.png',
                width: 32,
                height: 32,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF374151),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.smart_toy, color: Colors.white, size: 18),
                  );
                },
              ),
            ),
          ),
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  margin: EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: Color(0xFF374151),
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  width: 8,
                  height: 8,
                  margin: EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: Color(0xFF374151),
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  width: 8,
                  height: 8,
                  margin: EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: Color(0xFF374151),
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatBubble(ChatMessage message) {
    final userProvider = context.read<UserProvider>();
    final userInitial = userProvider.user?.username?.isNotEmpty == true
        ? userProvider.user!.username[0].toUpperCase()
        : 'Y';

    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: message.isFromBot
            ? MainAxisAlignment.start
            : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (message.isFromBot) ...[
            Container(
              width: 32,
              height: 32,
              margin: EdgeInsets.only(right: 8, bottom: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/kepala_bot.png',
                  width: 32,
                  height: 32,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF374151),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.smart_toy,
                        color: Colors.white,
                        size: 18,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: message.isFromBot
                    ? Colors.white.withOpacity(0.9)
                    : Color(0xFFE5E7EB).withOpacity(0.9),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                message.content,
                style: TextStyle(
                  color: Color(0xFF374151),
                  fontSize: 12,
                  height: 1.4,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          if (!message.isFromBot) ...[
            Container(
              width: 36,
              height: 36,
              margin: EdgeInsets.only(left: 8, bottom: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: ClipOval(
                child: Container(
                  color: Color(0xFFFED7AA),
                  child: Center(
                    child: Text(
                      userInitial,
                      style: TextStyle(
                        color: Color(0xFF9A3412),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Color(0xFFE5E7EB), width: 1),
                ),
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'Ketik pesan untuk ChampBot..',
                    hintStyle: TextStyle(
                      color: Color(0xFF9CA3AF),
                      fontSize: 14,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  style: TextStyle(fontSize: 14, color: Color(0xFF374151)),
                  maxLines: null,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (value) => _sendMessage(),
                ),
              ),
            ),
            SizedBox(width: 8),
            GestureDetector(
              onTap: _sendMessage,
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Color(0xFF475569),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF475569).withOpacity(0.3),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(Icons.send, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendMessage() async {
    final messageText = _messageController.text.trim();
    if (messageText.isEmpty || _isBotTyping || _currentSessionId == null)
      return;

    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      _messageController.clear();
      final userMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: messageText,
        isFromBot: false,
        timestamp: DateTime.now(),
        sessionId: _currentSessionId!,
      );

      if (mounted) {
        setState(() {
          messages.add(userMessage);
          _isBotTyping = true;
        });
      }

      _scrollToBottom();

      try {
        await _chatService.saveMessage(
          sessionId: _currentSessionId!,
          content: messageText,
          isFromBot: false,
        );
      } catch (saveError) {
        print('❌ Error saving user message: $saveError');
      }

      String botResponse;
      try {
        botResponse = await _geminiService.generateResponse(
          prompt: messageText,
          context: context,
          history: messages,
        );
      } catch (geminiError) {
        print('❌ Error getting bot response: $geminiError');
        botResponse =
            'Maaf, saya mengalami kesulitan memproses permintaan Anda. Silakan coba lagi.';
      }

      // Add bot message to UI
      final botMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: botResponse,
        isFromBot: true,
        timestamp: DateTime.now(),
        sessionId: _currentSessionId!,
      );

      if (mounted) {
        setState(() {
          messages.add(botMessage);
          _isBotTyping = false;
        });
      }

      try {
        await _chatService.saveMessage(
          sessionId: _currentSessionId!,
          content: botResponse,
          isFromBot: true,
        );
      } catch (saveBotError) {
        print('❌ Error saving bot response: $saveBotError');
        // Don't show error to user since message is already displayed
      }

      _scrollToBottom();
    } catch (e) {
      print('❌ General error in _sendMessage: $e');
      if (mounted) {
        setState(() => _isBotTyping = false);
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text('Terjadi kesalahan. Silakan coba lagi.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _scrollToBottom() {
    if (!mounted) return;

    Future.delayed(Duration(milliseconds: 100), () {
      if (mounted && _scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
