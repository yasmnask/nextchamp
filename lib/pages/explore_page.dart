import 'package:flutter/material.dart';
import 'package:nextchamp/pages/home_page.dart';

class ExplorePage extends StatefulWidget {
  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  int _selectedIndex = 1; // Explore tab selected

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigasi berdasarkan tab yang dipilih
    switch (index) {
      case 0: // Community
        // TODO: Navigasi ke Community page
        break;
      case 1: // Explore
        // Sudah di Explore, tidak perlu navigasi
        break;
      case 2: // Home
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
        break;
      case 3: // Course Bot
        // TODO: Navigasi ke Course Bot page
        break;
      case 4: // Mentor
        // TODO: Navigasi ke Mentor page
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF8FA2B7), // Light blue-gray
              Color(0xFF9BB0C4), // Slightly lighter
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(child: _buildScrollableContent()),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        children: [
          // User Profile Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFFED7AA), // orange-200
                    ),
                    child: Center(
                      child: Text(
                        'ZY',
                        style: TextStyle(
                          color: Color(0xFF9A3412), // orange-800
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Zakiyah Yasmin!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Level 3',
                        style: TextStyle(
                          color: Color(0xFFE2E8F0), // slate-200
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.star, color: Color(0xFFFB923C), size: 14),
                        SizedBox(width: 4),
                        Text(
                          '3600 Stars',
                          style: TextStyle(
                            color: Color(0xFF334155),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12),
                  Icon(
                    Icons.notifications_outlined,
                    color: Colors.white,
                    size: 24,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
          // Search Bar
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Color(0xFF64748B), // slate-500
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Click here to search the course!',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                Row(
                  children: [
                    Icon(Icons.search, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Icon(Icons.tune, color: Colors.white, size: 20),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScrollableContent() {
    final courses = [
      {
        'title': 'One Day One Design?',
        'subtitle': 'Design course for beginner who want get attitude.',
        'color': Color(0xFFF1F5F9),
        'illustration': '🤔',
        'questionMarks': true,
      },
      {
        'title': 'Knowing Market',
        'subtitle': 'You have to know how to research market.',
        'color': Color(0xFFF1F5F9),
        'illustration': '🎯',
        'questionMarks': false,
      },
      {
        'title': 'Let\'s Work Together!',
        'subtitle': 'How to manage project and the team.',
        'color': Color(0xFFF1F5F9),
        'illustration': '🤝',
        'questionMarks': false,
      },
      {
        'title': 'Backend Tips and Trick',
        'subtitle': 'All of simple tutorial about backend is here!',
        'color': Color(0xFFF1F5F9),
        'illustration': '💻',
        'questionMarks': false,
      },
      {
        'title': 'Focus for This Day!',
        'subtitle': 'Let\'s manage our schedule and get focus!',
        'color': Color(0xFFF1F5F9),
        'illustration': '⭐',
        'questionMarks': false,
      },
      {
        'title': 'What\'s Study Strategy?',
        'subtitle': 'Do you comfortable learning by listening music?',
        'color': Color(0xFFF1F5F9),
        'illustration': '📚',
        'questionMarks': false,
      },
      {
        'title': 'It\'s OK! Study Carefully',
        'subtitle': 'Let\'s get now about how to NOT burn out!',
        'color': Color(0xFFF1F5F9),
        'illustration': '✅',
        'questionMarks': false,
      },
      {
        'title': 'Tips for Business Man',
        'subtitle': 'Let\'s amazing to be a successful business man!',
        'color': Color(0xFFF1F5F9),
        'illustration': '💼',
        'questionMarks': false,
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFF8FAFC), // Very light gray
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: ListView.builder(
          itemCount: courses.length,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.only(bottom: 16),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: courses[index]['color'] as Color,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                courses[index]['title'] as String,
                                style: TextStyle(
                                  color: Color(0xFF1E293B),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            if (courses[index]['questionMarks'] == true) ...[
                              SizedBox(width: 8),
                              Text(
                                '? ? ?',
                                style: TextStyle(
                                  color: Color(0xFFEF4444),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          courses[index]['subtitle'] as String,
                          style: TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16),
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        courses[index]['illustration'] as String,
                        style: TextStyle(fontSize: 32),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBottomNavigation() {
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
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.people_outline, 'Community', 0),
              _buildNavItem(Icons.public, 'Explore', 1),
              _buildNavItem(Icons.home, 'Home', 2),
              _buildNavItem(Icons.smart_toy_outlined, 'Course Bot', 3),
              _buildNavItem(Icons.school_outlined, 'Mentor', 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index), // Gunakan fungsi navigasi
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFF334155) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Color(0xFF94A3B8),
              size: 24,
            ),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Color(0xFF94A3B8),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
