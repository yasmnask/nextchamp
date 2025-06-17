import 'package:flutter/material.dart';
import 'package:nextchamp/pages/champbot_page.dart';
import 'package:nextchamp/pages/community_page.dart';
import 'package:nextchamp/pages/explore_page.dart';
import 'package:nextchamp/pages/home_page.dart';
import 'package:nextchamp/pages/load_chatbot_page.dart';
import 'package:nextchamp/pages/mentor_page.dart';
import 'package:nextchamp/pages/learning_page.dart'; // Import page baru
import 'package:nextchamp/providers/bottom_navigation_provider.dart';
import 'package:provider/provider.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  _BottomNavigation createState() => _BottomNavigation();
}

class _BottomNavigation extends State<BottomNavigation> {
  final List<Widget> _pages = [
    CommunityPage(),
    ExplorePage(),
    HomePage(),
    LoadChatbotPage(),
    MentorPage(),
  ];

  void _onItemTapped(BuildContext context, int index) {
    context.read<BottomNavigationProvider>().setPage(index);
  }

  @override
  Widget build(BuildContext context) {
    final navProvider = context.watch<BottomNavigationProvider>();

    _pages[3] = (navProvider.champBotConfig)
        ? ChampbotPage()
        : LoadChatbotPage();

    return Scaffold(
      body: _pages[navProvider.currentIndex],
      bottomNavigationBar: Container(
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
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: _buildNavItem(Icons.people_outline, 'Community', 0),
                ),
                Expanded(child: _buildNavItem(Icons.public, 'Explore', 1)),
                Expanded(child: _buildNavItem(Icons.home, 'Home', 2)),
                Expanded(
                  child: _buildNavItem(
                    Icons.smart_toy_outlined,
                    'Champ Bot',
                    3,
                  ),
                ),
                Expanded(
                  child: _buildNavItem(Icons.school_outlined, 'Mentor', 4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected =
        context.watch<BottomNavigationProvider>().currentIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(context, index),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        margin: EdgeInsets.symmetric(horizontal: 2),
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
              size: 20,
            ),
            SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Color(0xFF94A3B8),
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
