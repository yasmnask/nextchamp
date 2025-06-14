import 'package:flutter/material.dart';
import 'package:nextchamp/models/user_model.dart';
import 'package:nextchamp/providers/user_provider.dart';
import 'package:nextchamp/utils/string_utils.dart';
import 'package:nextchamp/components/header_homepage.dart';
import 'package:nextchamp/components/profile_section.dart';
import 'package:provider/provider.dart';
import 'package:redacted/redacted.dart';
import '../providers/category_provider.dart';
import '../providers/course_provider.dart';
import 'package:nextchamp/core/dio_client.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoadingCategories = false;
  String? _categoryError;
  bool _isLoadingCourses = false;
  String? _courseError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCategories();
      _loadCourses();
    });
  }

  Future<void> _loadCategories() async {
    if (!mounted) return;

    setState(() {
      _isLoadingCategories = true;
      _categoryError = null;
    });

    try {
      final categoryProvider = Provider.of<CategoryProvider>(
        context,
        listen: false,
      );
      await categoryProvider.loadCategories(refresh: true);

      if (!mounted) return;

      if (categoryProvider.error != null) {
        setState(() {
          _categoryError = categoryProvider.error;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _categoryError = 'Failed to load categories: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingCategories = false;
        });
      }
    }
  }

  Future<void> _loadCourses() async {
    if (!mounted) return;

    setState(() {
      _isLoadingCourses = true;
      _courseError = null;
    });

    try {
      final courseProvider = Provider.of<CourseProvider>(
        context,
        listen: false,
      );
      await courseProvider.loadCourses(
        refresh: true,
        sortField: 'createdAt',
        sortDesc: true,
      );

      if (!mounted) return;

      if (courseProvider.error != null) {
        setState(() {
          _courseError = courseProvider.error;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _courseError = 'Failed to load courses: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingCourses = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false).user;

    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(color: Color(0xFFF3F4F6)),

          // Scrollable content that goes behind the header
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                // Space for the header (this will be behind the clipped header)
                SizedBox(height: 305),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(color: Color(0xFFF3F4F6)),
                  child: Column(
                    children: [
                      // Chat bot section
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.0),
                        child: _buildChatBot(),
                      ),

                      // Content sections
                      _buildContent(),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Fixed header on top (this stays in place)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: HeaderCurvedClipper(),
              child: Container(
                color: Color(0xFF8FA2B7),
                child: SafeArea(
                  child: Column(
                    children: [
                      HeaderHomepage(),
                      _buildUserProfile(user),
                      _buildSearchBar(),
                      SizedBox(height: 30), // Space for the curve
                    ],
                  ),
                ),
              ),
            ),
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
    return Container(
      margin: EdgeInsets.only(bottom: 25), // Add some spacing below
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
    );
  }

  Widget _buildContent() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xFFF3F4F6), // gray-100
      ),
      child: Column(
        children: [
          // Categories grid
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: _buildCategoriesGrid(),
          ),
          SizedBox(height: 25),
          // Course recommendation
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: _buildCourseRecommendation(),
          ),
          SizedBox(height: 20),
          // Courses grid
          Padding(
            padding: EdgeInsets.only(left: 25.0, right: 25.0, bottom: 25.0),
            child: _buildCoursesGrid(),
          ),
          SizedBox(height: 5), // Space for bottom navigation
        ],
      ),
    );
  }

  Widget _buildCategoriesGrid() {
    return Consumer<CategoryProvider>(
      builder: (context, categoryProvider, child) {
        final categories = categoryProvider.categories;
        final bool isLoading =
            _isLoadingCategories || categoryProvider.isLoading;

        // Show error message if there's an error
        if (_categoryError != null && !isLoading) {
          return Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFFFEE2E2), // light red background
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Color(0xFFFCA5A5)),
            ),
            child: Column(
              children: [
                Text(
                  'Failed to load categories',
                  style: TextStyle(
                    color: Color(0xFFB91C1C),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Times New Roman',
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  _categoryError!,
                  style: TextStyle(
                    color: Color(0xFFB91C1C),
                    fontSize: 12,
                    fontFamily: 'Times New Roman',
                  ),
                ),
                SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _loadCategories,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF3498DB),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('Try Again'),
                ),
              ],
            ),
          );
        }

        // Show empty state if no categories and not loading
        if (categories.isEmpty && !isLoading) {
          return Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFFF3EEEA),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                'No categories available',
                style: TextStyle(
                  color: Color(0xFF1F2937),
                  fontSize: 14,
                  fontFamily: 'Times New Roman',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        }

        // Create placeholder items for skeleton loading
        final int itemCount = isLoading && categories.isEmpty
            ? 4
            : categories.length;

        // Show categories grid with redacted skeleton loading
        return GridView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 15,
            childAspectRatio: 2.2,
          ),
          itemCount: itemCount,
          itemBuilder: (context, index) {
            // Get category name or use placeholder
            final String categoryName = isLoading && categories.isEmpty
                ? 'Loading...'
                : categories[index].name;

            return Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(0xFFF3EEEA),
                borderRadius: BorderRadius.circular(12),
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
                  categoryName,
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
            ).redacted(context: context, redact: isLoading);
          },
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
    return Consumer<CourseProvider>(
      builder: (context, courseProvider, child) {
        final courses = courseProvider.courses;
        final bool isLoading = _isLoadingCourses || courseProvider.isLoading;

        // Show error message if there's an error
        if (_courseError != null && !isLoading) {
          return Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFFFEE2E2), // light red background
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Color(0xFFFCA5A5)),
            ),
            child: Column(
              children: [
                Text(
                  'Failed to load courses',
                  style: TextStyle(
                    color: Color(0xFFB91C1C),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Times New Roman',
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  _courseError!,
                  style: TextStyle(
                    color: Color(0xFFB91C1C),
                    fontSize: 12,
                    fontFamily: 'Times New Roman',
                  ),
                ),
                SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _loadCourses,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF3498DB),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('Try Again'),
                ),
              ],
            ),
          );
        }

        // Show empty state if no courses and not loading
        if (courses.isEmpty && !isLoading) {
          return Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFFF3EEEA),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                'No courses available',
                style: TextStyle(
                  color: Color(0xFF1F2937),
                  fontSize: 14,
                  fontFamily: 'Times New Roman',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        }

        // Fallback colors and icons for courses
        final fallbackStyles = [
          {
            'bgColor': Color(0xFFFEF3C7),
            'iconColor': Color(0xFF3B82F6),
            'icon': Icons.business_center,
          },
          {
            'bgColor': Color(0xFFFECACA),
            'iconColor': Color(0xFFEF4444),
            'icon': Icons.analytics,
          },
          {
            'bgColor': Color(0xFFDBEAFE),
            'iconColor': Color(0xFF2563EB),
            'icon': Icons.trending_up,
          },
          {
            'bgColor': Color(0xFFDCFCE7),
            'iconColor': Color(0xFF22C55E),
            'icon': Icons.attach_money,
          },
          {
            'bgColor': Color(0xFFF3E8FF),
            'iconColor': Color(0xFFA855F7),
            'icon': Icons.campaign,
          },
          {
            'bgColor': Color(0xFFE0E7FF),
            'iconColor': Color(0xFF6366F1),
            'icon': Icons.settings,
          },
        ];

        // Create placeholder items for skeleton loading
        final int itemCount = isLoading && courses.isEmpty ? 6 : courses.length;

        return Container(
          padding: EdgeInsets.only(top: 30, left: 24, right: 24, bottom: 15),
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
            padding: EdgeInsets.zero,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 100,
              mainAxisSpacing: 20,
              crossAxisSpacing: 22,
              childAspectRatio: 0.8,
            ),
            itemCount: itemCount,
            itemBuilder: (context, index) {
              // Get course data or use placeholder
              final String courseTitle = isLoading && courses.isEmpty
                  ? 'Loading...'
                  : courses[index].title;

              // Use fallback styling with cycling colors
              final fallback = fallbackStyles[index % fallbackStyles.length];
              final bgColor = fallback['bgColor'] as Color;
              final iconColor = fallback['iconColor'] as Color;
              final fallbackIcon = fallback['icon'] as IconData;

              // Get course icon URL if available
              final String? iconUrl = isLoading && courses.isEmpty
                  ? null
                  : courses[index].iconUrl;

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: bgColor,
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
                      child: iconUrl != null && iconUrl.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                _buildMediaUrl(iconUrl),
                                width: 32,
                                height: 32,
                                fit: BoxFit.cover,
                                headers: {'Accept': 'image/*'},
                                errorBuilder: (context, error, stackTrace) {
                                  print('Failed to load image: $iconUrl');
                                  print(
                                    'Full URL attempted: ${_buildMediaUrl(iconUrl)}',
                                  );
                                  return Icon(
                                    fallbackIcon,
                                    color: iconColor,
                                    size: 28,
                                  );
                                },
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                iconColor,
                                              ),
                                        ),
                                      );
                                    },
                              ),
                            )
                          : Icon(fallbackIcon, color: iconColor, size: 28),
                    ),
                  ).redacted(context: context, redact: isLoading),
                  SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      courseTitle,
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
                    ).redacted(context: context, redact: isLoading),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  String _buildMediaUrl(String iconUrl) {
    if (iconUrl.startsWith('http')) {
      // Already a full URL
      return iconUrl;
    }

    // Get base URL without /api suffix for media files
    final dioBaseUrl = DioClient().baseUrl;
    final baseUrl = dioBaseUrl.endsWith('/api')
        ? dioBaseUrl.substring(0, dioBaseUrl.length - 4) // Remove /api
        : dioBaseUrl;

    // Ensure proper URL construction
    if (iconUrl.startsWith('/')) {
      return '$baseUrl$iconUrl';
    } else {
      return '$baseUrl/$iconUrl';
    }
  }
}

// Modified clipper that only clips the header section
class HeaderCurvedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    // Start from top-left
    path.moveTo(0, 0);

    // Draw the top and sides normally
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height - 30);

    // Create the curve at the bottom
    path.quadraticBezierTo(
      size.width * 0.5, // Control point X (center)
      size.height + 10, // Control point Y (curve extends down)
      0, // End point X (left side)
      size.height - 30, // End point Y
    );

    // Complete the left edge back to start
    path.lineTo(0, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
