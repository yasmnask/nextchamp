import 'package:flutter/material.dart';
import 'package:nextchamp/models/user_model.dart';
import 'package:nextchamp/providers/user_provider.dart';
import 'package:nextchamp/utils/string_utils.dart';
import 'package:nextchamp/widgets/header_homepage.dart';
import 'package:nextchamp/widgets/profile_section.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false).user;

    return Scaffold(
      body: Stack(
        children: [
          Container(color: Color(0xFFF3F4F6)),
          Column(
            children: [
              ClipPath(
                clipper: CurvedBottomClipper(),
                child: Container(
                  color: Color(0xFF8FA2B7), // Solid blue-gray color
                  child: SafeArea(
                    child: Column(
                      children: [
                        HeaderHomepage(),
                        _buildUserProfile(user),
                        _buildSearchBar(),
                        SizedBox(height: 20), // Space for the curve
                      ],
                    ),
                  ),
                ),
              ),

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
    );
  }

  Widget _buildUserProfile(User? user) {
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
                        user != null
                            ? StringUtils.getInitials(user.fullname)
                            : 'NC',
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
              ProfileSection(),
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
                Icon(Icons.star, color: Color(0xFFFB923C), size: 15),
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
            SizedBox(height: 25),
            _buildCourseRecommendation(),
            SizedBox(height: 20),
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
                color: Color(0xFF1F2937),
                fontSize: 12,
                fontFamily: 'Times New Roman',
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
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
      padding: EdgeInsets.only(left: 24, right: 24, bottom: 24),
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
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 100,
          mainAxisSpacing: 32,
          crossAxisSpacing: 22,
          childAspectRatio: 0.8,
        ),
        itemCount: courses.length,
        itemBuilder: (context, index) {
          return Column(
            mainAxisSize: MainAxisSize.min,
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
              SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: Text(
                  courses[index]['title'] as String,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontFamily: 'Times New Roman',
                    fontWeight: FontWeight.w500,
                    height: 1.1,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                ),
              ),
            ],
          );
        },
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
