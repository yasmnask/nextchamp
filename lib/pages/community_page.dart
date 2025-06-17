import 'package:flutter/material.dart';
import 'learning_page.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      body: Stack(
        children: [
          // Background gradient effect - sama seperti chatbot_page
          Positioned(
            top: MediaQuery.of(context).size.height * 0.30,
            left: MediaQuery.of(context).size.width * 0.1,
            right: MediaQuery.of(context).size.width * 0.1,
            height: MediaQuery.of(context).size.height * 0.5,
            child: Image.asset(
              'assets/gradasi_bg_bot.png',
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                // Fallback gradient jika gambar tidak ada
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
                        SizedBox(height: 24),
                        _buildWelcomeSection(),
                        SizedBox(height: 32),
                        _buildExploreCommunitySection(context),
                        SizedBox(height: 24),
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
              Text(
                'Community',
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

  Widget _buildWelcomeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Grow Together, Learn Better',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E293B),
            fontFamily: 'Times New Roman',
          ),
        ),
        SizedBox(height: 12),
        Text(
          'Temukan cara baru untuk berkembang lewat kolaborasi, komunitas, dan pengetahuan belajar yang seru. Mulai dari belajar dasar, riset bareng, hingga membangun proyek nyata—semua bisa kamu eksplor di sini!',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF64748B),
            height: 1.5,
            fontFamily: 'Times New Roman',
          ),
        ),
      ],
    );
  }

  Widget _buildExploreCommunitySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Explore Community',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
            fontFamily: 'Times New Roman',
          ),
        ),
        SizedBox(height: 20),
        _buildCommunityCard(
          context: context,
          title: 'Join Learning Group',
          subtitle: 'A beginner-friendly course designed to help you build a professional mindset and skills',
          imageName: 'join_learning_group',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LearningPage()),
            );
          },
        ),
        SizedBox(height: 16),
        _buildCommunityCard(
          context: context,
          title: 'Forum Discussion',
          subtitle: 'Collaborate and sharpen your research skills to solve widespread life matters',
          imageName: 'forum_discuss',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Forum Discussion clicked!')),
            );
          },
        ),
        SizedBox(height: 16),
        _buildCommunityCard(
          context: context,
          title: 'Community Event',
          subtitle: 'Learn how to manage projects effectively and work across without a miss',
          imageName: 'community_event',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Community Event clicked!')),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCommunityCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String imageName,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: Offset(0, 4),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E293B),
                      fontFamily: 'Times New Roman',
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF475569),
                      height: 1.4,
                      fontFamily: 'Times New Roman',
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16),
            Container(
              width: 80,
              height: 80,
              child: Image.asset(
                'assets/$imageName.png',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getIconForCard(title),
                      size: 40,
                      color: Color(0xFF64748B),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForCard(String title) {
    switch (title) {
      case 'Join Learning Group':
        return Icons.group;
      case 'Forum Discussion':
        return Icons.forum;
      case 'Community Event':
        return Icons.event;
      default:
        return Icons.people;
    }
  }
}
