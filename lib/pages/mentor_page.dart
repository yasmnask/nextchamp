import 'package:flutter/material.dart';
import 'package:nextchamp/models/user_model.dart';
import 'package:nextchamp/providers/user_provider.dart';
import 'package:nextchamp/utils/string_utils.dart';
import 'package:provider/provider.dart';

class MentorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC), // Light background
      body: Column(
        children: [
          _buildHeader(user),
          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 24.0),
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
        ],
      ),
    );
  }

  Widget _buildHeader(User? user) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF8FA2B7), // Blue-gray
            Color(0xFF7A8FA4), // Slightly darker
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: Offset(0, 4),
            spreadRadius: 2,
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            children: [
              // User profile row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // User info
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFFED7AA), // orange-200
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            user != null
                                ? StringUtils.getInitials(user.fullname)
                                : 'NC',
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
                            user != null 
                                ? StringUtils.capitalizeWords(
                                    StringUtils.takeFirstWords(user.fullname, 2),
                                  ) + '!'
                                : 'NextChamp User!',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Level 3',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 12,
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
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.star, color: Color(0xFFFB923C), size: 16),
                            SizedBox(width: 6),
                            Text(
                              '3600 Stars',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF334155),
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(Icons.arrow_forward_ios, color: Color(0xFFFB923C), size: 12),
                          ],
                        ),
                      ),
                      SizedBox(width: 12),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.notifications_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              
              SizedBox(height: 16),
              
              // Search bar
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: Color(0xFF475569), // slate-600
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Klik di sini untuk mencari mentor!',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                          fontFamily: 'Times New Roman',
                        ),
                      ),
                    ),
                    Icon(Icons.search, color: Colors.white, size: 20),
                    SizedBox(width: 12),
                    Icon(Icons.tune, color: Colors.white, size: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedMentor() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFDCEDFB), // Light blue background
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 15,
            offset: Offset(0, 6),
            spreadRadius: 3,
          ),
        ],
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
                    'BEST MENTOR OF APRIL!',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                      color: Color(0xFF1E293B), // slate-800
                      fontFamily: 'Times New Roman',
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Rahman Irawan, S.Kom.',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: Color(0xFF334155), // slate-700
                      fontFamily: 'Times New Roman',
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Expert in Advanced Robotics Engineering',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF475569), // slate-600
                      fontFamily: 'Times New Roman',
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF334155), // slate-700
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 3,
                      shadowColor: Colors.black.withOpacity(0.3),
                      textStyle: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    child: Text('Click to Connect with Mentor!'),
                  ),
                ],
              ),
            ),
            
            // Mentor image - menggunakan foto asli
            Container(
              width: 90,
              height: 110,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  color: Colors.white,
                  child: Image.asset(
                    'assets/rahman_irawan.png',
                    fit: BoxFit.contain, // Ganti dari cover ke contain biar ga kepotong
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.person,
                          size: 50,
                          color: Color(0xFF334155),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMentorGrid() {
    // List mentor dengan foto asli sesuai dengan yang tersedia
    final mentors = [
      {
        'name': 'Jamal Ramadhan',
        'expertise': 'Ahli dalam programming, software engineering, dan product development',
        'image': 'assets/jamal.png',
        'specialization': 'Mentor GEMASTIK',
        'bgColor': Color(0xFFFEF3C7), // yellow background
      },
      {
        'name': 'Arka Hayati B',
        'expertise': 'Ahli dalam UI/UX design, product, dan project management',
        'image': 'assets/arka_hayati.png',
        'specialization': 'Mentor PKM',
        'bgColor': Color(0xFFDBEAFE), // blue background
      },
      {
        'name': 'Rahmatulah Windrey',
        'expertise': 'Ahli dalam user research, interview design thinking, wireframing, mockup, visual design',
        'image': 'assets/windrey.png',
        'specialization': 'Mentor UI/UX',
        'bgColor': Color(0xFFF3E8FF), // purple background
      },
      {
        'name': 'Afifah Rahmay',
        'expertise': 'Ahli dalam business, financial, product development, dan startup pitching',
        'image': 'assets/afifah.png',
        'specialization': 'Mentor Business',
        'bgColor': Color(0xFFFECACA), // red background
      },
      {
        'name': 'Intan Handayani',
        'expertise': 'Ahli dalam strategic business model, goal setting, dan marketing',
        'image': 'assets/intan.png',
        'specialization': 'Mentor Marketing',
        'bgColor': Color(0xFFDCFCE7), // green background
      },
      {
        'name': 'Nadia Zahra',
        'expertise': 'Ahli dalam data analysis, machine learning, dan visualization',
        'image': 'assets/nadia.png',
        'specialization': 'Mentor Data Science',
        'bgColor': Color(0xFFE0E7FF), // indigo background
      },
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.65,
        ),
        itemCount: mentors.length,
        itemBuilder: (context, index) {
          return _buildMentorCard(
            name: mentors[index]['name']! as String,
            expertise: mentors[index]['expertise']! as String,
            imagePath: mentors[index]['image']! as String,
            specialization: mentors[index]['specialization']! as String,
            bgColor: mentors[index]['bgColor']! as Color,
          );
        },
      ),
    );
  }

  Widget _buildMentorCard({
    required String name,
    required String expertise,
    required String imagePath,
    required Color bgColor,
    required String specialization,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 15,
            offset: Offset(0, 6),
            spreadRadius: 3,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mentor image dengan background berwarna
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: bgColor.withOpacity(0.2),
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              ),
              padding: EdgeInsets.all(12),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    color: Colors.white,
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.contain, // Ganti dari cover ke contain biar ga kepotong
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.person,
                            size: 40,
                            color: Color(0xFF64748B), // slate-500
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          // Content section
          Expanded(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Specialization badge
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Color(0xFF1E293B), // slate-800
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
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
                  
                  SizedBox(height: 8),
                  
                  // Mentor name
                  Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: Color(0xFF1E293B), // slate-800
                      fontFamily: 'Times New Roman',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  SizedBox(height: 6),
                  
                  // Expertise
                  Expanded(
                    child: Text(
                      expertise,
                      style: TextStyle(
                        fontSize: 10,
                        color: Color(0xFF64748B), // slate-500
                        height: 1.3,
                        fontFamily: 'Times New Roman',
                      ),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
