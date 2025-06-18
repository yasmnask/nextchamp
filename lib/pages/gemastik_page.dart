import 'package:flutter/material.dart';

class GemastikPage extends StatelessWidget {
  const GemastikPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      body: Stack(
        children: [
          // Background gradient effect
          Positioned(
            top: MediaQuery.of(context).size.height * 0.15,
            left: MediaQuery.of(context).size.width * 0.05,
            right: MediaQuery.of(context).size.width * 0.05,
            height: MediaQuery.of(context).size.height * 0.7,
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
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        _buildGroupCard(context),
                        SizedBox(height: 24),
                        _buildGroupPreview(),
                        SizedBox(
                          height: 100,
                        ), // Extra space for bottom navigation
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF1E293B), // Dark navy blue
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
              Text(
                'Learning Group',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Times New Roman',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGroupCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Group image
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.asset(
                'assets/gemastik_group.jpg',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFFEF3C7),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.emoji_events,
                        size: 80,
                        color: Color(0xFF92400E),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Content
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kebut GEMASTIK 2026!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                    fontFamily: 'Times New Roman',
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Grup belajar intensif untuk persiapan GEMASTIK 2026. Diskusi soal, tryout rutin, dan tips strategi lolos GEMASTIK yang di lampirkan!',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF475569),
                    height: 1.5,
                    fontFamily: 'Times New Roman',
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () => _showJoinConfirmation(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF1E293B),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 3,
                    ),
                    child: Text(
                      'Join Now',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showJoinConfirmation(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Confirm to Join the Group?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                    fontFamily: 'Times New Roman',
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12),
                Text(
                  'you will allow to read all the message and get the feedback from the other members.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF64748B),
                    height: 1.4,
                    fontFamily: 'Times New Roman',
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFF1F5F9), // Light gray
                          foregroundColor: Color(0xFF64748B),
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'No',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); // Close dialog
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatGroupPage(
                                groupName: 'Kebut GEMASTIK 2026!',
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF1E293B), // Dark navy
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 2,
                        ),
                        child: Text(
                          'Yes',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGroupPreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Group Preview',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
            fontFamily: 'Times New Roman',
          ),
        ),
        SizedBox(height: 16),
        _buildPostCard(
          username: '@Pandu',
          timeAgo: '2h mins ago',
          content:
              'Nih guys aku mau poster lomba nih, ada yang mau ikutan? Kalo mau ikutan langsung aja ya, jangan lupa baca syarat dan ketentuannya dulu ya!',
          imageName: 'gemastik_poster.jpg',
          likes: 24,
          comments: 12,
          shares: 3,
        ),
        SizedBox(height: 16),
        _buildPostCard(
          username: '@Pandu',
          timeAgo: '1 day ago',
          content:
              'guys mau tanya dong, kalau mau daftar lomba nih, syaratnya apa aja sih? yang pernah ikut lomba bagi pengalaman dong, makasih',
          imageName: null,
          likes: 18,
          comments: 8,
          shares: 2,
        ),
      ],
    );
  }

  Widget _buildPostCard({
    required String username,
    required String timeAgo,
    required String content,
    String? imageName,
    required int likes,
    required int comments,
    required int shares,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User info
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF3B82F6),
                ),
                child: Center(
                  child: Text(
                    'P',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      username,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    Text(
                      timeAgo,
                      style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 12),

          // Content
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF374151),
              height: 1.4,
              fontFamily: 'Times New Roman',
            ),
          ),

          // Image if exists
          if (imageName != null) ...[
            SizedBox(height: 12),
            Container(
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  'assets/$imageName',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.image,
                          size: 40,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],

          SizedBox(height: 12),

          // Actions
          Row(
            children: [
              _buildActionButton(Icons.favorite_border, likes.toString()),
              SizedBox(width: 20),
              _buildActionButton(
                Icons.chat_bubble_outline,
                comments.toString(),
              ),
              SizedBox(width: 20),
              _buildActionButton(Icons.share_outlined, shares.toString()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String count) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Color(0xFF64748B)),
        SizedBox(width: 4),
        Text(count, style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
      ],
    );
  }
}

// Chat Group Page Class - Added directly to avoid import issues
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
      text: "Terima kasih teman! Thank you yaa, selamat bergabung!",
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
              _buildBottomNavigation(context),
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
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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

  Widget _buildBottomNavigation(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF475569), // slate-600
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(child: _buildNavItem(Icons.people, 'Community', 0)),
              Expanded(child: _buildNavItem(Icons.public, 'Explore', 1)),
              Expanded(child: _buildNavItem(Icons.home, 'Home', 2)),
              Expanded(child: _buildNavItem(Icons.smart_toy, 'Champ Bot', 3)),
              Expanded(
                child: _buildNavItem(Icons.school_outlined, 'Mentor', 4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isActive = index == 0; // Community active karena ini grup chat

    return GestureDetector(
      onTap: () {
        // Navigation logic
        if (index == 2) {
          Navigator.popUntil(context, (route) => route.isFirst);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        margin: EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: isActive ? Color(0xFF334155) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? Colors.white : Color(0xFF94A3B8),
              size: 20,
            ),
            SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : Color(0xFF94A3B8),
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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
