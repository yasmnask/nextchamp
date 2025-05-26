import 'package:flutter/material.dart';
import 'package:nextchamp/pages/explore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 2; // Home tab selected by default

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
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ExplorePage()),
        );
        break;
      case 2: // Home
        // Sudah di Home, tidak perlu navigasi
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
      body: Stack(
        children: [
          // Background color for the entire screen
          Container(
            color: Color(0xFFF3F4F6), // gray-100 background
          ),
          Column(
            children: [
              // Header section with curved bottom - FIXED (tidak kena scroll)
              ClipPath(
                clipper: CurvedBottomClipper(),
                child: Container(
                  color: Color(0xFF8FA2B7), // Solid blue-gray color
                  child: SafeArea(
                    child: Column(
                      children: [
                        _buildHeader(),
                        _buildUserProfile(),
                        _buildSearchBar(),
                        SizedBox(height: 20), // Space for the curve
                      ],
                    ),
                  ),
                ),
              ),
              // Scrollable content - MULAI DARI SINI
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 10), // Jarak kecil dari lengkungan
                      // ChatBot section
                      _buildChatBot(),
                      SizedBox(height: 0), // Kontrol manual jarak antar section
                      // Content section
                      _buildContent(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.fromLTRB(24, 16, 24, 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.settings, color: Colors.white, size: 24),
              SizedBox(width: 12),
              Text(
                'Welcome, Yasmin!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Icon(Icons.notifications_outlined, color: Colors.white, size: 24),
        ],
      ),
    );
  }

  Widget _buildUserProfile() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: ClipOval(
                  child: Container(
                    color: Color(0xFFFED7AA), // orange-200
                    child: Center(
                      child: Text(
                        'ZY',
                        style: TextStyle(
                          color: Color(0xFF9A3412), // orange-800
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Zakiyah Yasmin',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Times New Roman',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Level 3',
                    style: TextStyle(
                      color: Color(0xFFE2E8F0), // slate-200
                      fontSize: 14,
                      fontFamily: 'poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  Icons.star,
                  color: Color.fromARGB(255, 254, 214, 68),
                  size: 16,
                ),
                SizedBox(width: 8),
                Text(
                  '3600 Stars',
                  style: TextStyle(
                    color: Color(0xFF334155), // slate-700
                    fontSize: 13,
                    fontFamily: 'poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 8),
                Icon(
                  Icons.star,
                  color: Color.fromARGB(255, 254, 214, 68),
                  size: 16,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.all(17.0),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xFF64748B), // slate-500 - darker for contrast
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Click here to search the mission!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontFamily: 'Times New Roman',
              ),
            ),
            Icon(Icons.search, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildChatBot() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.0),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xFF475569), // slate-600 - darker for contrast
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Hi! Wanna ask me?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'Times New Roman',
                fontWeight: FontWeight.w700,
              ),
            ),
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Color(0xFF60A5FA), // blue-400
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Color(0xFF60A5FA),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xFFF3F4F6), // gray-100
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: 25.0,
          right: 25.0,
          bottom: 25.0,
        ), // no top padding
        child: Column(
          children: [
            _buildCategoriesGrid(),
            SizedBox(height: 24),
            _buildCourseRecommendation(),
            SizedBox(height: 24),
            _buildCoursesGrid(),
            SizedBox(height: 20), // Space for bottom navigation
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesGrid() {
    final categories = [
      {'title': 'Program Kreativitas Mahasiswa'},
      {'title': 'Business Plan Competition'},
      {'title': 'GEMASTIK'},
      {'title': 'UI/UX Design Competition'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio:
            2.2, // Diperbesar untuk membuat container lebih kecil tingginya
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.all(12), // Padding diperkecil
          decoration: BoxDecoration(
            color: Color(0xFFF3EEEA), // Single color for all categories
            borderRadius: BorderRadius.circular(12), // Border radius diperkecil
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              categories[index]['title'] as String,
              style: TextStyle(
                color: Color(0xFF1F2937), // gray-800
                fontSize: 12, // Font size diperkecil
                fontFamily: 'Times New Roman', // Times New Roman font
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 2, // Maksimal 2 baris
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
      },
    );
  }

  Widget _buildCourseRecommendation() {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Color(0xFF1E293B), // slate-800
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.1), // yellow-400
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Center(child: Text('📚', style: TextStyle(fontSize: 32))),
          ),
          SizedBox(width: 16),
          Text(
            'The course you might like',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'Times New Roman',
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoursesGrid() {
    final courses = [
      {
        'title': 'Dasar-dasar Business Plan',
        'bgColor': Color(0xFFFEF3C7),
        'iconColor': Color(0xFF3B82F6),
        'icon': Icons.business_center, // Business icon
      },
      {
        'title': 'Riset Pasar & Analisis Kompetitor',
        'bgColor': Color(0xFFFECACA),
        'iconColor': Color(0xFFEF4444),
        'icon': Icons.analytics, // Analytics icon
      },
      {
        'title': 'Model Bisnis & Strategi Monetisasi',
        'bgColor': Color(0xFFDBEAFE),
        'iconColor': Color(0xFF2563EB),
        'icon': Icons.trending_up, // Strategy/growth icon
      },
      {
        'title': 'Bagian Aspek Keuangan',
        'bgColor': Color(0xFFDCFCE7),
        'iconColor': Color(0xFF22C55E),
        'icon': Icons.attach_money, // Money icon
      },
      {
        'title': 'Strategi Pemasaran & Branding',
        'bgColor': Color(0xFFF3E8FF),
        'iconColor': Color(0xFFA855F7),
        'icon': Icons.campaign, // Marketing icon
      },
      {
        'title': 'Aspek Operasional & Teknologi',
        'bgColor': Color(0xFFE0E7FF),
        'iconColor': Color(0xFF6366F1),
        'icon': Icons.settings, // Operations/tech icon
      },
    ];

    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Color(0xFF475569), // slate-600
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 24,
          mainAxisSpacing: 24,
          childAspectRatio: 0.8,
        ),
        itemCount: courses.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: courses[index]['bgColor'] as Color,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    courses[index]['icon'] as IconData,
                    color: courses[index]['iconColor'] as Color,
                    size: 28,
                  ),
                ),
              ),
              SizedBox(height: 12),
              Text(
                courses[index]['title'] as String,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontFamily: 'Times New Roman', // Times New Roman font
                  fontWeight: FontWeight.w500,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBottomNavigation() {
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
      onTap: () => _onItemTapped(index),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Color(0xFF334155)
              : Colors.transparent, // slate-700
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Color(0xFF94A3B8), // slate-300
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

// Custom clipper untuk lengkungan tepat di bawah search bar
class CurvedBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    // Mulai dari kiri atas
    path.lineTo(0, size.height - 30);

    // Membuat kurva halus yang melengkung ke bawah
    path.quadraticBezierTo(
      size.width * 0.5, // Control point X (tepat di tengah)
      size.height +
          10, // Control point Y (sedikit ke bawah untuk lengkungan halus)
      size.width, // End point X (kanan)
      size.height - 30, // End point Y (sama tinggi dengan start point)
    );

    // Ke kanan atas
    path.lineTo(size.width, 0);
    // Kembali ke kiri atas
    path.lineTo(0, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
