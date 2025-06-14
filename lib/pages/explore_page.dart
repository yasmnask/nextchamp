import 'package:flutter/material.dart';
import 'package:nextchamp/models/user_model.dart';
import 'package:nextchamp/providers/app_state_provider.dart';
import 'package:nextchamp/providers/user_provider.dart';
import 'package:nextchamp/providers/course_provider.dart';
import 'package:nextchamp/providers/category_provider.dart';
import 'package:nextchamp/utils/string_utils.dart';
import 'package:nextchamp/core/dio_client.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'dart:async';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  late final AppStateProvider appState;
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

  final List<String> _fallbackIcons = [
    '🤔',
    '🎯',
    '🤝',
    '💻',
    '⭐',
    '📚',
    '✅',
    '💼',
    '🚀',
    '💡',
    '🎨',
    '📊',
    '🔧',
    '🌟',
    '📱',
    '🎵',
    '🏆',
    '🎪',
    '🎭',
    '🎬',
    '📸',
    '🎮',
    '🏃',
    '⚽',
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

    // Fix: Remove overlay without calling setState
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }

    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    appState = context.read<AppStateProvider>();

    if (appState.selectedCategoryId != null && _selectedCategoryId == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _filterByCategory(
          appState.selectedCategoryId,
          appState.selectedCategoryName,
        );
      });
    }
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
      final courseProvider = Provider.of<CourseProvider>(
        context,
        listen: false,
      );
      final categoryProvider = Provider.of<CategoryProvider>(
        context,
        listen: false,
      );

      await Future.wait([
        categoryProvider.loadCategories(refresh: true),
        courseProvider.loadCourses(
          refresh: true,
          sortField: 'createdAt',
          sortDesc: true,
          categoryId: _selectedCategoryId,
        ),
      ]);

      if (mounted) {
        if (courseProvider.error != null) {
          setState(() {
            _error = courseProvider.error;
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
      final courseProvider = Provider.of<CourseProvider>(
        context,
        listen: false,
      );

      // Fix: Always use searchCourses and pass the category filter
      await courseProvider.searchCourses(
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
      // Add this check
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
      final courseProvider = Provider.of<CourseProvider>(
        context,
        listen: false,
      );

      if (_isSearchActive && _searchController.text.isNotEmpty) {
        await courseProvider.searchCourses(
          _searchController.text,
          categoryId: categoryId,
          sortField: 'createdAt',
          sortDesc: true,
        );
      } else {
        // Otherwise, load courses with category filter
        await courseProvider.loadCourses(
          categoryId: categoryId,
          refresh: true,
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
        left: offset.dx - 150, // Adjust position to align properly
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
                            onTap: () => {
                              _filterByCategory(null, null),
                              appState.clearCategory(),
                            },
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

  String _getRandomIcon(int index) {
    final random = Random(index); // Use index as seed for consistency
    return _fallbackIcons[random.nextInt(_fallbackIcons.length)];
  }

  String _buildMediaUrl(String iconUrl) {
    if (iconUrl.startsWith('http')) {
      return iconUrl;
    }

    final dioBaseUrl = DioClient().baseUrl;
    final baseUrl = dioBaseUrl.endsWith('/api')
        ? dioBaseUrl.substring(0, dioBaseUrl.length - 4)
        : dioBaseUrl;

    if (iconUrl.startsWith('/')) {
      return '$baseUrl$iconUrl';
    } else {
      return '$baseUrl/$iconUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false).user;

    return GestureDetector(
      onTap: () {
        // Close dropdown when tapping outside
        if (_isDropdownOpen) {
          _removeOverlay();
        }
        // Unfocus search field when tapping outside
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
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
                _buildHeader(user),
                Expanded(child: _buildScrollableContent()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(User? user) {
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
                        StringUtils.capitalizeWords(
                          StringUtils.takeFirstWords(user!.fullname, 2),
                        ),
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
          // Search Bar - Now with inline input and dropdown filter
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            decoration: BoxDecoration(
              color: Color(0xFF64748B), // slate-500
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
                      hintText: 'Search courses...',
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
                    if (_searchController.text.isNotEmpty && _isSearchActive)
                      GestureDetector(
                        onTap: () {
                          _searchController.clear();
                          _searchFocusNode.unfocus();
                          // Fix: Immediately reset search state
                          setState(() {
                            _isSearchActive = false;
                          });
                          // Cancel any pending debounce and reload data
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
                      appState.clearCategory(),
                    },
                    child: Icon(Icons.close, color: Colors.white, size: 16),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildScrollableContent() {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(24),
        topRight: Radius.circular(24),
      ),
      child: Container(
        color: Color(0xFFF8FAFC),
        child: Column(
          children: [
            Expanded(
              child: Consumer<CourseProvider>(
                builder: (context, courseProvider, child) {
                  // Show error if exists
                  if (_error != null && !_isLoading) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Error loading courses',
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

                  // Get courses based on search state
                  final courses = _isSearchActive
                      ? courseProvider.searchResults
                      : courseProvider.courses;

                  // Show loading
                  if (_isLoading && courses.isEmpty) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF1E293B),
                      ),
                    );
                  }

                  // Show empty state
                  if (courses.isEmpty && !_isLoading) {
                    IconData emptyIcon;
                    String message;

                    if (_isSearchActive) {
                      emptyIcon = Icons.search_off;
                      message = 'No courses found for your search.';
                    } else if (_selectedCategoryName != null) {
                      emptyIcon = Icons.category_outlined;
                      message = 'No courses found in this category.';
                    } else {
                      emptyIcon = Icons.menu_book_outlined;
                      message = 'No courses available.';
                    }

                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            emptyIcon,
                            size: 72,
                            color: Colors.grey.shade400,
                          ),
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
                          if (_isSearchActive ||
                              _selectedCategoryName != null) ...[
                            ElevatedButton.icon(
                              onPressed: () {
                                _searchController.clear();
                                _debounceTimer?.cancel();
                                setState(() {
                                  _isSearchActive = false;
                                  _selectedCategoryId = null;
                                  _selectedCategoryName = null;
                                });
                                appState.clearCategory();
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

                  return ListView.builder(
                    padding: EdgeInsets.only(top: 20, bottom: 20),
                    physics: BouncingScrollPhysics(),
                    itemCount: courses.length,
                    itemBuilder: (context, index) {
                      final course = courses[index];

                      return Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.19),
                              blurRadius: 25,
                              offset: Offset(0, 8),
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    course.title,
                                    style: TextStyle(
                                      color: Color(0xFF1E293B),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Times New Roman',
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    course.description,
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 46, 57, 72),
                                      fontSize: 14,
                                      height: 1.4,
                                      fontFamily: 'Times New Roman',
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
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
                                child:
                                    course.iconUrl != null &&
                                        course.iconUrl!.isNotEmpty
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          _buildMediaUrl(course.iconUrl!),
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                                return Text(
                                                  _getRandomIcon(course.id),
                                                  style: TextStyle(
                                                    fontSize: 32,
                                                  ),
                                                );
                                              },
                                          loadingBuilder:
                                              (
                                                context,
                                                child,
                                                loadingProgress,
                                              ) {
                                                if (loadingProgress == null)
                                                  return child;
                                                return SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child:
                                                      CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                      ),
                                                );
                                              },
                                        ),
                                      )
                                    : Text(
                                        _getRandomIcon(course.id),
                                        style: TextStyle(fontSize: 32),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
