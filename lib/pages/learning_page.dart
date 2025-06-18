import 'package:flutter/material.dart';
import 'gemastik_page.dart'; // Make sure this import is correct

class LearningPage extends StatefulWidget {
  const LearningPage({Key? key}) : super(key: key);

  @override
  _LearningPageState createState() => _LearningPageState();
}

class _LearningPageState extends State<LearningPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isSearching = false;

  // Data grup pembelajaran
  final List<Map<String, dynamic>> _allGroups = [
    {
      'title': 'Kebut GEMASTIK 2026!',
      'description':
          'Grup belajar intensif untuk persiapan GEMASTIK 2026. Sharing tips, strategi, dan tips terbaik biar lolos GEMASTIK. Yuk gabung!',
      'imageName': 'gemastik_group.jpg',
      'backgroundColor': Color(0xFFFEF3C7),
      'keywords': [
        'gemastik',
        'kompetisi',
        'programming',
        'teknologi',
        'lomba',
      ],
      'onTap': 'gemastik_page',
    },
    {
      'title': 'Kita Cinta Matematika',
      'description':
          'Komunitas pecinta matematika dari berbagai jenjang. Cocok buat kamu yang ingin eksplor dunia matematika atau baru belajar dasar.',
      'imageName': 'math_group.jpg',
      'backgroundColor': Color(0xFFDCFCE7),
      'keywords': ['matematika', 'math', 'hitung', 'rumus', 'belajar'],
      'onTap': null,
    },
    {
      'title': 'Tips n Trick PKM',
      'description':
          'Belajar bareng cara bikin proposal PKM yang lolos! Dibimbing dengan sharing pengalaman dari tim yang sudah pernah di PKM.',
      'imageName': 'pkm_group.png',
      'backgroundColor': Color(0xFFDBEAFE),
      'keywords': ['pkm', 'proposal', 'penelitian', 'mahasiswa', 'kreativitas'],
      'onTap': null,
    },
    {
      'title': 'Kejar Beasiswa Mapres',
      'description':
          'Komunitas mahasiswa berprestasi yang saling berbagi tips beasiswa, lomba, dan prestasi akademik non-akademik.',
      'imageName': 'mapres_group.jpg',
      'backgroundColor': Color(0xFFF3E8FF),
      'keywords': [
        'beasiswa',
        'mapres',
        'prestasi',
        'scholarship',
        'mahasiswa',
      ],
      'onTap': null,
    },
    {
      'title': 'Public Speaking Club',
      'description':
          'Komunitas seru untuk melatih kemampuan berbicara di depan umum. Cocok buat kamu yang mau jadi lebih percaya diri!',
      'imageName': 'speaking_group.jpg',
      'backgroundColor': Color(0xFFFECACA),
      'keywords': [
        'public speaking',
        'berbicara',
        'presentasi',
        'komunikasi',
        'percaya diri',
      ],
      'onTap': null,
    },
  ];

  List<Map<String, dynamic>> _filteredGroups = [];

  @override
  void initState() {
    super.initState();
    _filteredGroups = _allGroups;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
      _isSearching = _searchQuery.isNotEmpty;

      if (_searchQuery.isEmpty) {
        _filteredGroups = _allGroups;
      } else {
        _filteredGroups = _allGroups.where((group) {
          final title = group['title'].toString().toLowerCase();
          final description = group['description'].toString().toLowerCase();
          final keywords = (group['keywords'] as List<String>)
              .join(' ')
              .toLowerCase();

          return title.contains(_searchQuery) ||
              description.contains(_searchQuery) ||
              keywords.contains(_searchQuery);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      body: Stack(
        children: [
          // Background gradient effect - sama seperti chatbot_page
          Positioned(
            top: MediaQuery.of(context).size.height * 0.2,
            left: MediaQuery.of(context).size.width * 0.05,
            right: MediaQuery.of(context).size.width * 0.05,
            height: MediaQuery.of(context).size.height * 0.6,
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
                        SizedBox(height: 20),
                        _buildSearchBar(),
                        SizedBox(height: 24),
                        _buildContent(),
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
              Text(
                _isSearching ? 'Search Results' : 'Learning Group',
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

  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Color(0xFF64748B), // slate-500
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
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontFamily: 'Times New Roman',
              ),
              decoration: InputDecoration(
                hintText: 'Search learning Group',
                hintStyle: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                  fontFamily: 'Times New Roman',
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          Icon(Icons.search, color: Colors.white, size: 20),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_isSearching && _filteredGroups.isEmpty) {
      return _buildNoResultsFound();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!_isSearching) ...[
          Text(
            'Recommended Group',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
              fontFamily: 'Times New Roman',
            ),
          ),
          SizedBox(height: 16),
        ] else ...[
          Text(
            'Search Results (${_filteredGroups.length})',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
              fontFamily: 'Times New Roman',
            ),
          ),
          SizedBox(height: 16),
        ],
        ..._filteredGroups
            .map(
              (group) => Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: _buildGroupCard(
                  title: group['title'],
                  description: group['description'],
                  imageName: group['imageName'],
                  backgroundColor: group['backgroundColor'],
                  onTap: group['onTap'],
                ),
              ),
            )
            .toList(),
      ],
    );
  }

  Widget _buildNoResultsFound() {
    return Stack(
      children: [
        // Background gradient untuk no results
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xFFFFFBF0).withOpacity(0.5), // Very light cream/yellow
                  Color(0xFFF0F9FF).withOpacity(0.5), // Very light blue
                ],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  'Group not found.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF64748B),
                    fontFamily: 'Times New Roman',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Try searching with different keywords',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF94A3B8),
                  fontFamily: 'Times New Roman',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGroupCard({
    required String title,
    required String description,
    required String imageName,
    required Color backgroundColor,
    String? onTap,
  }) {
    return GestureDetector(
      onTap: () {
        print('Card tapped: $title, onTap: $onTap'); // Debug print
        if (onTap == 'gemastik_page') {
          print('Navigating to GemastikPage'); // Debug print
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => GemastikPage()),
          );
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('$title clicked!')));
        }
      },
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Group image
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: backgroundColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/$imageName',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _getIconForGroup(title),
                        size: 40,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              ),
            ),

            SizedBox(width: 16),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E293B),
                      fontFamily: 'Times New Roman',
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF475569),
                      height: 1.4,
                      fontFamily: 'Times New Roman',
                    ),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForGroup(String title) {
    switch (title) {
      case 'Kebut GEMASTIK 2026!':
        return Icons.emoji_events;
      case 'Kita Cinta Matematika':
        return Icons.calculate;
      case 'Tips n Trick PKM':
        return Icons.lightbulb;
      case 'Kejar Beasiswa Mapres':
        return Icons.school;
      case 'Public Speaking Club':
        return Icons.mic;
      default:
        return Icons.group;
    }
  }
}
