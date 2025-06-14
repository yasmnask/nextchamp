import 'package:flutter/material.dart';
import 'homepage.dart';
import 'load_chatbot.dart';

class ListMentorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchBar(),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      SizedBox(height: 16),
                      _buildFeaturedMentor(),
                      SizedBox(height: 16),
                      _buildMentorGrid(),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
            _buildBottomNavigation(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
      decoration: BoxDecoration(
        color: Color(0xFF8FA2B7), // Blue-gray color
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // User info
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 15,
                  backgroundColor: Color(0xFFFED7AA), // orange-200
                  child: Text(
                    'ZY',
                    style: TextStyle(
                      color: Color(0xFF9A3412), // orange-800
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Zakiyah Yasmin!',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    'Level 3',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          // Stars counter and notification
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Color(0xFFFACC15), // yellow-400
                      size: 14,
                    ),
                    SizedBox(width: 4),
                    Text(
                      '3600 Stars',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.play_arrow,
                      color: Color(0xFFFACC15), // yellow-400
                      size: 14,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8),
              Icon(
                Icons.notifications_outlined,
                color: Colors.white,
                size: 22,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: Color(0xFF475569), // slate-600
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 16),
                child: Text(
                  'Click here to search the course!',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            Container(
              width: 44,
              height: 44,
              child: Icon(
                Icons.search,
                color: Colors.white,
                size: 18,
              ),
            ),
            Container(
              width: 44,
              height: 44,
              child: Icon(
                Icons.menu,
                color: Colors.white,
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedMentor() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFDCEDFB), // Light blue background
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'BEST MENTOR IN APRIL!',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                      color: Color(0xFF1E293B), // slate-800
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Rahman Irawan, S.Kom.',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: Color(0xFF334155), // slate-700
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Expertise in Advanced Robotics engineering',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF475569), // slate-600
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF334155), // slate-700
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      textStyle: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    child: Text('Click here to Connect with mentor!'),
                  ),
                ],
              ),
            ),
            
            // Mentor image
            Container(
              width: 90,
              height: 110,
              child: Image.asset(
                'assets/mentor_featured.png',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.person,
                    size: 70,
                    color: Color(0xFF334155),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMentorGrid() {
    // List of mentors with their specializations
    final mentors = [
      {
        'name': 'Jamal Ramadhan',
        'expertise': 'Expertise in programming, software engineering, and product development',
        'image': 'assets/mentor_jamal.png',
        'specialization': 'Mentor GEMASTIK',
      },
      {
        'name': 'Arka Hayati B',
        'expertise': 'Expertise in UI/UX design, product, and project management',
        'image': 'assets/mentor_arka.png',
        'specialization': 'Mentor PKM',
      },
      {
        'name': 'Rahmatulah Windrey',
        'expertise': 'Expertise in user research, interview design thinking, wireframing, mockup, visual design',
        'image': 'assets/mentor_rahmat.png',
        'specialization': 'Mentor UI/UX',
      },
      {
        'name': 'Afifah Rahmay',
        'expertise': 'Expertise in business, financial, product development, and startup pitching',
        'image': 'assets/mentor_afifah.png',
        'specialization': 'Mentor Business',
      },
      {
        'name': 'Intan Handayani',
        'expertise': 'Expert in strategic business model, goal setting, and marketing',
        'image': 'assets/mentor_intan.png',
        'specialization': 'Mentor Marketing',
      },
      {
        'name': 'Nadia Zahra',
        'expertise': 'Expert in data analysis, machine learning, and visualization',
        'image': 'assets/mentor_nadia.png',
        'specialization': 'Mentor Data Science',
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemCount: mentors.length,
      itemBuilder: (context, index) {
        return _buildMentorCard(
          name: mentors[index]['name']!,
          expertise: mentors[index]['expertise']!,
          imagePath: mentors[index]['image']!,
          specialization: mentors[index]['specialization']!,
        );
      },
    );
  }

  Widget _buildMentorCard({
    required String name,
    required String expertise,
    required String imagePath,
    required String specialization,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Mentor image
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: Container(
                width: double.infinity,
                color: Color(0xFFF1F5F9), // slate-100
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.person,
                      size: 50,
                      color: Color(0xFF64748B), // slate-500
                    );
                  },
                ),
              ),
            ),
          ),
          
          // Mentor specialization
          Padding(
            padding: EdgeInsets.fromLTRB(10, 6, 10, 2),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Color(0xFF1E293B), // slate-800
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  specialization,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          
          // Mentor name and expertise
          Padding(
            padding: EdgeInsets.fromLTRB(10, 2, 10, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: Color(0xFF1E293B), // slate-800
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2),
                Text(
                  expertise,
                  style: TextStyle(
                    fontSize: 9,
                    color: Color(0xFF64748B), // slate-500
                    height: 1.3,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF1E293B), // slate-800
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
              _buildNavItem(context, Icons.people_outline, 'Community', 0),
              _buildNavItem(context, Icons.public, 'Explore', 1),
              _buildNavItem(context, Icons.home, 'Home', 2, onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              }),
              _buildNavItem(context, Icons.smart_toy_outlined, 'Champ Bot', 3, onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoadChatbotScreen()),
                );
              }),
              _buildNavItem(context, Icons.school_outlined, 'Mentor', 4, isActive: true),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, String label, int index, {bool isActive = false, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? Colors.white : Color(0xFF94A3B8), // slate-400
            size: 22,
          ),
          SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.white : Color(0xFF94A3B8),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
