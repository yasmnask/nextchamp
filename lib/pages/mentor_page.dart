import 'package:flutter/material.dart';
import 'package:nextchamp/models/mentor_model.dart';
import 'package:nextchamp/models/user_model.dart';
import 'package:nextchamp/providers/user_provider.dart';
import 'package:nextchamp/providers/mentor_provider.dart';
import 'package:nextchamp/providers/category_provider.dart';
import 'package:nextchamp/utils/string_utils.dart';
import 'package:nextchamp/core/dio_client.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'dart:async';

class MentorPage extends StatefulWidget {
  const MentorPage({super.key});

  @override
  _MentorPageState createState() => _MentorPageState();
}

class _MentorPageState extends State<MentorPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  Timer? _debounceTimer;
  bool _isSearchActive = false;
  int? _selectedCategoryId;
  String? _selectedCategoryName;
  bool _isLoading = false;
  String? _error;

  final GlobalKey _filterButtonKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  bool _isDropdownOpen = false;

  // Fallback mentor images
  final List<String> _fallbackImages = [
    'assets/jamal.png',
    'assets/windrey.png',
    'assets/arka_hayati.png',
    'assets/afifah.png',
    'assets/intan.png',
    'assets/nadia.png',
  ];

  // Random colors for mentor cards
  final List<Color> _cardColors = [
    Color(0xFFFEF3C7), // yellow
    Color(0xFFDBEAFE), // blue
    Color(0xFFF3E8FF), // purple
    Color(0xFFFECACA), // red
    Color(0xFFDCFCE7), // green
    Color(0xFFE0E7FF), // indigo
    Color(0xFFFED7AA), // orange
    Color(0xFFE5E7EB), // gray
  ];

  bool _hasLoadedInitialData = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _searchFocusNode.dispose();
    _debounceTimer?.cancel();

    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }

    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      final searchTerm = _searchController.text.trim();
      if (searchTerm.isEmpty) {
        if (mounted) {
          setState(() {
            _isSearchActive = false;
          });
          _loadInitialData(force: true);
        }
      } else {
        _performSearch(searchTerm);
      }
    });
  }

  Future<void> _loadInitialData({bool force = false}) async {
    if (_hasLoadedInitialData && !force) return;

    if (mounted) {
      setState(() {
        _isLoading = true;
        _error = null;
      });
    }

    try {
      final mentorProvider = Provider.of<MentorProvider>(
        context,
        listen: false,
      );
      final categoryProvider = Provider.of<CategoryProvider>(
        context,
        listen: false,
      );

      await Future.wait([
        categoryProvider.loadCategories(refresh: true),
        mentorProvider.loadMentors(
          refresh: true,
          sortField: 'createdAt',
          sortDesc: true,
          categoryId: _selectedCategoryId,
        ),
        mentorProvider.loadFeaturedMentors(refresh: true),
      ]);

      if (mounted) {
        if (mentorProvider.error != null) {
          setState(() {
            _error = mentorProvider.error;
          });
        } else {
          _hasLoadedInitialData = true;
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to load data: $e';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _performSearch(String searchTerm) async {
    if (mounted) {
      setState(() {
        _isSearchActive = true;
        _isLoading = true;
      });
    }

    try {
      final mentorProvider = Provider.of<MentorProvider>(
        context,
        listen: false,
      );

      await mentorProvider.searchMentors(
        searchTerm,
        categoryId: _selectedCategoryId,
        sortField: 'createdAt',
        sortDesc: true,
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Search failed: $e';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (mounted) {
      setState(() {
        _isDropdownOpen = false;
      });
    }
  }

  Future<void> _filterByCategory(int? categoryId, String? categoryName) async {
    setState(() {
      _selectedCategoryId = categoryId;
      _selectedCategoryName = categoryName;
      _isLoading = true;
    });

    _removeOverlay();

    try {
      final mentorProvider = Provider.of<MentorProvider>(
        context,
        listen: false,
      );

      if (_isSearchActive && _searchController.text.isNotEmpty) {
        await mentorProvider.searchMentors(
          _searchController.text,
          categoryId: categoryId,
          sortField: 'createdAt',
          sortDesc: true,
        );
      } else {
        await mentorProvider.filterByCategory(
          categoryId,
          sortField: 'createdAt',
          sortDesc: true,
        );
      }
    } catch (e) {
      setState(() {
        _error = 'Filter failed: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _toggleDropdown() {
    if (_isDropdownOpen) {
      _removeOverlay();
    } else {
      _showDropdown();
    }
  }

  void _showDropdown() {
    final RenderBox renderBox =
        _filterButtonKey.currentContext!.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx - 150,
        top: offset.dy + size.height + 5,
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 200,
            constraints: BoxConstraints(maxHeight: 300),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Consumer<CategoryProvider>(
              builder: (context, categoryProvider, child) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Color(0xFF8FA2B7),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Filter by Category',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          GestureDetector(
                            onTap: _removeOverlay,
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Categories list
                    Flexible(
                      child: ListView(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        children: [
                          _buildDropdownItem(
                            title: 'All Categories',
                            isSelected: _selectedCategoryId == null,
                            onTap: () => _filterByCategory(null, null),
                          ),
                          ...categoryProvider.categories.map((category) {
                            return _buildDropdownItem(
                              title: category.name,
                              isSelected: _selectedCategoryId == category.id,
                              onTap: () =>
                                  _filterByCategory(category.id, category.name),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    setState(() {
      _isDropdownOpen = true;
    });
  }

  Widget _buildDropdownItem({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? Color(0xFF8FA2B7).withOpacity(0.1)
              : Colors.transparent,
        ),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: isSelected ? Color(0xFF8FA2B7) : Colors.grey,
              size: 18,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: isSelected ? Color(0xFF8FA2B7) : Color(0xFF334155),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _buildMediaUrl(String profileUrl) {
    if (profileUrl.startsWith('http')) {
      return profileUrl;
    }

    final dioBaseUrl = DioClient().baseUrl;
    final baseUrl = dioBaseUrl.endsWith('/api')
        ? dioBaseUrl.substring(0, dioBaseUrl.length - 4)
        : dioBaseUrl;

    if (profileUrl.startsWith('/')) {
      return '$baseUrl$profileUrl';
    } else {
      return '$baseUrl/$profileUrl';
    }
  }

  String _getFallbackImage(int index) {
    final random = Random(index);
    return _fallbackImages[random.nextInt(_fallbackImages.length)];
  }

  Color _getRandomColor(int index) {
    final random = Random(index);
    return _cardColors[random.nextInt(_cardColors.length)];
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false).user;

    return GestureDetector(
      onTap: () {
        if (_isDropdownOpen) {
          _removeOverlay();
        }
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Color(0xFFF8FAFC),
        body: Column(
          children: [
            _buildHeader(user),
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    SizedBox(height: 25),
                    _buildFeaturedMentor(),
                    SizedBox(height: 25),
                    _buildMentorGrid(),
                    SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(User? user) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF8FA2B7), Color(0xFF7A8FA4)],
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
          padding: EdgeInsets.fromLTRB(16, 12, 16, 20),
          child: Column(
            children: [
              // User profile row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // User info
                  Flexible(
                    flex: 2,
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFFED7AA),
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
                                color: Color(0xFF9A3412),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user != null
                                    ? StringUtils.capitalizeWords(
                                            StringUtils.takeFirstWords(
                                              user.fullname,
                                              2,
                                            ),
                                          ) +
                                          '!'
                                    : 'NextChamp User!',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
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
                        ),
                      ],
                    ),
                  ),

                  // Stars counter and notification
                  Flexible(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Flexible(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
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
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Color(0xFFFB923C),
                                  size: 16,
                                ),
                                SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    '3600 Stars',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF334155),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(width: 3),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Color(0xFFFB923C),
                                  size: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
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
                  ),
                ],
              ),

              SizedBox(height: 16),

              // Search bar with functional text field and filter
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: Color(0xFF64748B),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        focusNode: _searchFocusNode,
                        cursorColor: Colors.white,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Times New Roman',
                        ),
                        decoration: InputDecoration(
                          hintText: 'Cari mentor..',
                          hintStyle: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 14,
                            fontFamily: 'Times New Roman',
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 8),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        if (_searchController.text.isNotEmpty &&
                            _isSearchActive)
                          GestureDetector(
                            onTap: () {
                              _searchController.clear();
                              _searchFocusNode.unfocus();
                              setState(() {
                                _isSearchActive = false;
                              });
                              _debounceTimer?.cancel();
                              _loadInitialData(force: true);
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              child: Icon(
                                Icons.clear,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        Icon(Icons.search, color: Colors.white, size: 20),
                        SizedBox(width: 8),
                        GestureDetector(
                          key: _filterButtonKey,
                          onTap: _toggleDropdown,
                          child: Container(
                            padding: EdgeInsets.all(2),
                            child: Stack(
                              children: [
                                Icon(
                                  Icons.tune,
                                  color: _selectedCategoryId != null
                                      ? Color(0xFFFB923C)
                                      : Colors.white,
                                  size: 20,
                                ),
                                if (_selectedCategoryId != null)
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: Color(0xFFFB923C),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Active filter indicator
              if (_selectedCategoryName != null) ...[
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Filter: $_selectedCategoryName',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => {
                          setState(() {
                            _selectedCategoryId = null;
                            _selectedCategoryName = null;
                          }),
                          _filterByCategory(null, null),
                        },
                        child: Icon(Icons.close, color: Colors.white, size: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedMentor() {
    return Consumer<MentorProvider>(
      builder: (context, mentorProvider, child) {
        if (_isLoading && mentorProvider.featuredMentors.isEmpty) {
          return Container(
            height: 150,
            child: Center(
              child: CircularProgressIndicator(color: Color(0xFF1E293B)),
            ),
          );
        }

        if (mentorProvider.featuredMentors.isEmpty) {
          return SizedBox.shrink();
        }

        final featuredMentor = mentorProvider.featuredMentors.first;

        return Container(
          decoration: BoxDecoration(
            color: Color(0xFFDCEDFB),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Text content
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'BEST MENTOR OF JUNE!',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                          color: Color(0xFF1E293B),
                          fontFamily: 'Times New Roman',
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        featuredMentor.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: Color(0xFF334155),
                          fontFamily: 'Times New Roman',
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        featuredMentor.description,
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF475569),
                          fontFamily: 'Times New Roman',
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF334155),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 6,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 3,
                          shadowColor: Colors.black.withOpacity(0.3),
                          textStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        child: Text('Click to Connect with Mentor!'),
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 10),

                // Mentor image
                Flexible(
                  flex: 2,
                  child: Container(
                    constraints: BoxConstraints(maxWidth: 100, maxHeight: 110),
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
                        child:
                            featuredMentor.profileUrl != null &&
                                featuredMentor.profileUrl!.isNotEmpty
                            ? Image.network(
                                _buildMediaUrl(featuredMentor.profileUrl!),
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    _getFallbackImage(featuredMentor.id),
                                    fit: BoxFit.contain,
                                  );
                                },
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      );
                                    },
                              )
                            : Image.asset(
                                _getFallbackImage(featuredMentor.id),
                                fit: BoxFit.contain,
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMentorGrid() {
    return Consumer<MentorProvider>(
      builder: (context, mentorProvider, child) {
        // Show error if exists
        if (_error != null && !_isLoading) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Error loading mentors',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                SizedBox(height: 8),
                Text(_error!),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loadInitialData,
                  child: Text('Retry'),
                ),
              ],
            ),
          );
        }

        // Get mentors based on search state
        final mentors = _isSearchActive
            ? mentorProvider.searchResults
            : mentorProvider.mentors.where((m) => !m.isFeatured).toList();

        // Show loading
        if (_isLoading && mentors.isEmpty) {
          return Center(
            child: CircularProgressIndicator(color: Color(0xFF1E293B)),
          );
        }

        // Show empty state
        if (mentors.isEmpty && !_isLoading) {
          IconData emptyIcon;
          String message;

          if (_isSearchActive) {
            emptyIcon = Icons.search_off;
            message = 'No mentors found for your search.';
          } else if (_selectedCategoryName != null) {
            emptyIcon = Icons.category_outlined;
            message = 'No mentors found in this category.';
          } else {
            emptyIcon = Icons.person_outline;
            message = 'No mentors available.';
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(emptyIcon, size: 72, color: Colors.grey.shade400),
                SizedBox(height: 16),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12),
                if (_isSearchActive || _selectedCategoryName != null) ...[
                  ElevatedButton.icon(
                    onPressed: () {
                      _searchController.clear();
                      _debounceTimer?.cancel();
                      setState(() {
                        _isSearchActive = false;
                        _selectedCategoryId = null;
                        _selectedCategoryName = null;
                      });
                      _loadInitialData(force: true);
                    },
                    icon: Icon(Icons.clear),
                    label: Text('Clear All Filters'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF1E293B),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            int crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
            double childAspectRatio = constraints.maxWidth > 600 ? 0.7 : 0.68;

            return GridView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 12,
                mainAxisSpacing: 15,
                childAspectRatio: childAspectRatio,
              ),
              itemCount: mentors.length,
              itemBuilder: (context, index) {
                final mentor = mentors[index];
                return _buildMentorCard(
                  mentor: mentor,
                  bgColor: _getRandomColor(mentor.id),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildMentorCard({required Mentor mentor, required Color bgColor}) {
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
              padding: EdgeInsets.all(6),
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
                    child:
                        mentor.profileUrl != null &&
                            mentor.profileUrl!.isNotEmpty
                        ? Image.network(
                            _buildMediaUrl(mentor.profileUrl!),
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                _getFallbackImage(mentor.id),
                                fit: BoxFit.contain,
                              );
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              );
                            },
                          )
                        : Image.asset(
                            _getFallbackImage(mentor.id),
                            fit: BoxFit.contain,
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
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Specialization badge
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: Color(0xFF1E293B),
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
                      "Mentor ${mentor.categoryName}" ?? 'General',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  SizedBox(height: 6),

                  // Mentor name
                  Text(
                    mentor.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: Color(0xFF1E293B),
                      fontFamily: 'Times New Roman',
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: 4),

                  // Expertise (description)
                  Expanded(
                    child: Text(
                      mentor.description,
                      style: TextStyle(
                        fontSize: 9,
                        color: Color(0xFF64748B),
                        height: 1.2,
                        fontFamily: 'Times New Roman',
                      ),
                      maxLines: 5,
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
