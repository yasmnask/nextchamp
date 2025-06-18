import 'package:flutter/material.dart';

class ChatGroupPage extends StatefulWidget {
  final String groupName;

  const ChatGroupPage({Key? key, required this.groupName}) : super(key: key);

  @override
  _ChatGroupPageState createState() => _ChatGroupPageState();
}

class _ChatGroupPageState extends State<ChatGroupPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // List untuk menyimpan pesan chat grup
  List<GroupChatMessage> messages = [
    GroupChatMessage(
      text: "You joined the chat",
      isSystemMessage: true,
      timestamp: DateTime.now().subtract(Duration(minutes: 10)),
    ),
    GroupChatMessage(
      text: "Halooo, welcome! Selamat bergabung Yasmin!",
      isUser: false,
      senderName: "Selamat bergabung yaa, Yasmin!",
      timestamp: DateTime.now().subtract(Duration(minutes: 8)),
    ),
    GroupChatMessage(
      text: "Selamat bergabung temaan!",
      isUser: false,
      senderName: "Terima kasih teman!",
      timestamp: DateTime.now().subtract(Duration(minutes: 5)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      body: Stack(
        children: [
          // Background gradient effect - sama seperti halaman lain
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
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color(0xFFFFFBF0), // Very light cream/yellow
                        Color(0xFFF0F9FF), // Very light blue
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                );
              },
            ),
          ),

          Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return _buildChatBubble(messages[index]);
                  },
                ),
              ),
              _buildInputArea(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF475569), // slate-600
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.2),
                  ),
                  child: Icon(Icons.arrow_back, color: Colors.white, size: 20),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.groupName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Times New Roman',
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatBubble(GroupChatMessage message) {
    if (message.isSystemMessage) {
      return Padding(
        padding: EdgeInsets.only(bottom: 16),
        child: Center(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Color(0xFF64748B).withOpacity(0.8), // slate-500
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              message.text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: message.isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!message.isUser) ...[
            // Avatar untuk pesan dari orang lain
            Container(
              width: 32,
              height: 32,
              margin: EdgeInsets.only(right: 8, bottom: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF3B82F6), // blue-500
              ),
              child: Center(
                child: Text(
                  message.senderName?.substring(0, 1).toUpperCase() ?? 'U',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],

          // Message bubble
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: message.isUser
                    ? Color(0xFF475569).withOpacity(0.9) // slate-600 untuk user
                    : Colors.white.withOpacity(0.9), // putih untuk orang lain
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
                message.text,
                style: TextStyle(
                  color: message.isUser
                      ? Colors.white
                      : Color(0xFF374151), // Dark gray untuk pesan orang lain
                  fontSize: 14,
                  height: 1.4,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),

          if (message.isUser) ...[
            // Avatar untuk pesan user
            Container(
              width: 32,
              height: 32,
              margin: EdgeInsets.only(left: 8, bottom: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFFED7AA), // orange-200
              ),
              child: Center(
                child: Text(
                  'Y',
                  style: TextStyle(
                    color: Color(0xFF9A3412), // orange-800
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
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
                  color: Color(0xFFF3F4F6), // Light gray background
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: Color(0xFFE5E7EB), // Light border
                    width: 1,
                  ),
                ),
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'Ketik Pesan ke Grup',
                    hintStyle: TextStyle(
                      color: Color(0xFF9CA3AF), // Gray-400
                      fontSize: 14,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF374151), // Gray-700
                  ),
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
                  color: Color(0xFF475569), // slate-600
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

  void _sendMessage() {
    String messageText = _messageController.text.trim();
    if (messageText.isNotEmpty) {
      setState(() {
        messages.add(
          GroupChatMessage(
            text: messageText,
            isUser: true,
            timestamp: DateTime.now(),
          ),
        );
        _messageController.clear();
      });

      // Scroll to bottom
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
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

// Model untuk pesan grup chat
class GroupChatMessage {
  final String text;
  final bool isUser;
  final bool isSystemMessage;
  final String? senderName;
  final DateTime timestamp;

  GroupChatMessage({
    required this.text,
    this.isUser = false,
    this.isSystemMessage = false,
    this.senderName,
    required this.timestamp,
  });
}
