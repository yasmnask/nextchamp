import 'package:flutter/material.dart';
import 'home_page.dart';
import 'mentor_page.dart';
import 'load_chatbot_page.dart';

class CommunityPageScreen extends StatelessWidget {
  const CommunityPageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      body: Column(
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
                    _buildExploreCommunitySection(context), // Pass context here
                    SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigation(context),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF475569),
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
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
              SizedBox(width: 12),
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
          'Bergabunglah dengan komunitas belajar NextChamp, dan mari kita berbagi pengetahuan bersama. Mari kita menggali potensi yang terpendam belajar yang seru. Mari kita belajar dasar, riset bareng, hingga membangun proyek nyata—semua bisa kamu dapatkan kali ini!',
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

  Widget _buildExploreCommunitySection(BuildContext context) { // Add context parameter
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
          context: context, // Pass context
          title: 'Join Learning Group',
          subtitle: 'Bergabung dengan komunitas belajar dan tingkatkan skill kamu bersama-sama',
          imageName: 'join_learning_group',
          backgroundColor: Color(0xFFFEF3C7),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Join Learning Group clicked!')),
            );
          },
        ),
        SizedBox(height: 16),
        _buildCommunityCard(
          context: context, // Pass context
          title: 'Forum Discussion',
          subtitle: 'Diskusikan dan sharing your insights, tips dan best practice di forum',
          imageName: 'forum_discussion',
          backgroundColor: Color(0xFFDBEAFE),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Forum Discussion clicked!')),
            );
          },
        ),
        SizedBox(height: 16),
        _buildCommunityCard(
          context: context, // Pass context
          title: 'Community Event',
          subtitle: 'Ikuti dan ikutan events menarik dan seru bersama komunitas',
          imageName: 'community_event',
          backgroundColor: Color(0xFFDBEAFE),
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
    required BuildContext context, // Add context parameter
    required String title,
    required String subtitle,
    required String imageName,
    required Color backgroundColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
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
            Expanded(
              flex: 1,
              child: Container(
                height: 80,
                child: Image.asset(
                  'assets/$imageName.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),
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

  Widget _buildBottomNavigation(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF475569),
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
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context: context,
                icon: Icons.people,
                label: 'Community',
                index: 0,
                isActive: true,
              ),
              _buildNavItem(
                context: context,
                icon: Icons.public,
                label: 'Explore',
                index: 1,
              ),
              _buildNavItem(
                context: context,
                icon: Icons.home,
                label: 'Home',
                index: 2,
              ),
              _buildNavItem(
                context: context,
                icon: Icons.smart_toy,
                label: 'Champ Bot',
                index: 3,
              ),
              _buildNavItem(
                context: context,
                icon: Icons.school_outlined,
                label: 'Mentor',
                index: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context, // Add context parameter
    required IconData icon,
    required String label,
    required int index,
    bool isActive = false,
  }) {
    return GestureDetector(
      onTap: () {
        switch (index) {
          case 0: // Community - sudah di halaman ini
            break;
          case 1: // Explore
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Explore page coming soon!')),
            );
            break;
          case 2: // Home
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
            break;
          case 3: // Champ Bot
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoadChatbotPage()),
            );
            break;
          case 4: // Mentor
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MentorPage()),
            );
            break;
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
              size: 24,
            ),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : Color(0xFF94A3B8),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
