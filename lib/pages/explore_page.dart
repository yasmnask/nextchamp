import 'package:flutter/material.dart';
import 'package:nextchamp/models/user_model.dart';
import 'package:nextchamp/providers/user_provider.dart';
import 'package:nextchamp/utils/string_utils.dart';
import 'package:provider/provider.dart';

class ExplorePage extends StatefulWidget {
  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false).user;

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
              _buildHeader(user),
              Expanded(child: _buildScrollableContent()),
            ],
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
          // Search Bar
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Color(0xFF64748B), // slate-500
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Click here to search the course!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontFamily: 'Times New Roman',
                  ),
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
              child: ListView.builder(
                padding: EdgeInsets.only(top: 20, bottom: 20),
                physics: BouncingScrollPhysics(),
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: courses[index]['color'] as Color,
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
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      courses[index]['title'] as String,
                                      style: TextStyle(
                                        color: Color(0xFF1E293B),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Times New Roman',
                                      ),
                                    ),
                                  ),
                                  if (courses[index]['questionMarks'] ==
                                      true) ...[
                                    SizedBox(width: 8),
                                  ],
                                ],
                              ),
                              SizedBox(height: 8),
                              Text(
                                courses[index]['subtitle'] as String,
                                style: TextStyle(
                                  color: Color.fromARGB(255, 46, 57, 72),
                                  fontSize: 14,
                                  height: 1.4,
                                  fontFamily: 'Times New Roman',
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
          ],
        ),
      ),
    );
  }
}
