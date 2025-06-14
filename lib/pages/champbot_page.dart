import 'package:flutter/material.dart';

class ChampbotPage extends StatefulWidget {
  @override
  _ChampbotPageState createState() => _ChampbotPageState();
}

class _ChampbotPageState extends State<ChampbotPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // List untuk menyimpan pesan chat - sesuai dengan gambar
  List<ChatMessage> messages = [
    ChatMessage(
      text: "Hai Yasmin! Ada yang mau ditanyakan?",
      isBot: true,
      timestamp: DateTime.now().subtract(Duration(minutes: 5)),
    ),
    ChatMessage(
      text:
          "Ada nih, soalnya tiba agar kita bisa fokus setelah lomba dan perkembangan",
      isBot: false,
      timestamp: DateTime.now().subtract(Duration(minutes: 4)),
    ),
    ChatMessage(
      text:
          "Buat jadwal yang terorganisir. Tentukan prioritas, atur deadline lomba atau tugas kuliah dulu, utamakan yang paling mendesak. Gunakan waktu dengan bijak, jangan sampai terlalu lama scrolling bagi waktu, bagi kesempatan juga. Komunikasi dengan tim dan dosen. Biar mereka tahu kalau kamu sedang bagi waktu, jaga kesehatan juga. Semangat ya Yasmin!",
      isBot: true,
      timestamp: DateTime.now().subtract(Duration(minutes: 2)),
    ),
    ChatMessage(
      text: "Okey! terima kasih sudah membantu!",
      isBot: false,
      timestamp: DateTime.now().subtract(Duration(minutes: 1)),
    ),
  ];

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
        backgroundColor: Color(0xFF475569), // slate-600 to match design
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
      body: Container(
        color: Colors.white, // Background utama putih polos
        child: Stack(
          children: [
            // PNG Gradient background di tengah layar - tanpa border
            Positioned(
              top:
                  MediaQuery.of(context).size.height * 0.15, // Posisi dari atas
              left: MediaQuery.of(context).size.width * 0.1, // Posisi dari kiri
              right:
                  MediaQuery.of(context).size.width * 0.1, // Posisi dari kanan
              height:
                  MediaQuery.of(context).size.height * 0.5, // Tinggi gradasi
              child: Image.asset(
                'assets/gradasi_bg_bot.png',
                fit: BoxFit.contain, // Maintain aspect ratio
                errorBuilder: (context, error, stackTrace) {
                  // Fallback gradient tanpa border
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
                    ),
                  );
                },
              ),
            ),

            // Main chat content
            Column(
              children: [
                // Chat messages area
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

                // Input area
                _buildInputArea(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatBubble(ChatMessage message) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 20,
      ), // Increased spacing between messages
      child: Row(
        mainAxisAlignment: message.isBot
            ? MainAxisAlignment.start
            : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (message.isBot) ...[
            // Bot avatar - menggunakan kepala_bot.png
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
                    // Fallback jika gambar gagal dimuat
                    return Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF374151), // Dark gray for bot avatar
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

          // Message bubble
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth:
                    MediaQuery.of(context).size.width *
                    0.7, // Slightly narrower
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: message.isBot
                    ? Colors.white.withOpacity(
                        0.9,
                      ) // Semi-transparent white for bot
                    : Color(
                        0xFFE5E7EB,
                      ).withOpacity(0.9), // Light gray for user messages
                borderRadius: BorderRadius.circular(18), // More rounded
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
                  color: Color(0xFF374151), // Dark gray text for both
                  fontSize: 12,
                  height: 1.4,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),

          if (!message.isBot) ...[
            // User avatar - positioned at bottom right
            Container(
              width: 32,
              height: 32,
              margin: EdgeInsets.only(left: 8, bottom: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: ClipOval(
                child: Container(
                  color: Color(0xFFFED7AA), // orange-200 background
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
                    hintText: 'Ketik Pesan untuk Chatbot',
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
                  color: Color(0xFF475569), // Blue-500
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
        // Add user message
        messages.add(
          ChatMessage(
            text: messageText,
            isBot: false,
            timestamp: DateTime.now(),
          ),
        );

        // Clear input
        _messageController.clear();
      });

      // Scroll to bottom
      _scrollToBottom();

      // Simulate bot response (nanti diganti dengan API Gemini)
      _simulateBotResponse();
    }
  }

  void _simulateBotResponse() {
    // Simulate typing delay
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        messages.add(
          ChatMessage(
            text:
                "Terima kasih atas pertanyaannya! Saya akan membantu Anda. (Ini response sementara, nanti akan diganti dengan API Gemini)",
            isBot: true,
            timestamp: DateTime.now(),
          ),
        );
      });
      _scrollToBottom();
    });
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

// Model untuk chat message
class ChatMessage {
  final String text;
  final bool isBot;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isBot,
    required this.timestamp,
  });
}
