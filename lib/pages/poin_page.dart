import 'package:flutter/material.dart';

class PoinPage extends StatefulWidget {
  const PoinPage({super.key});

  @override
  _PoinPageState createState() => _PoinPageState();
}

class _PoinPageState extends State<PoinPage> {
  int _selectedIndex = 2; // Home tab selected by default
  int _selectedTab = 0; // 0 for "Misi Anda", 1 for "Leaderboard"
  int _currentPoints = 3600;
  int _currentDay = 2; // Current check-in day (0-6)

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigation based on selected tab
    switch (index) {
      case 0: // Community
        // TODO: Navigate to Community page
        break;
      case 1: // Explore
        // TODO: Navigate to Explore page
        break;
      case 2: // Home
        // TODO: Navigate to Home page
        break;
      case 3: // ChampBot
        // TODO: Navigate to ChampBot page
        break;
      case 4: // Mentor
        // TODO: Navigate to Mentor page
        break;
    }
  }

  void _checkIn() {
    setState(() {
      if (_currentDay < 6) {
        _currentDay++;
        _currentPoints += _getPointsForDay(_currentDay);
      }
    });

    // Show custom check-in success dialog instead of SnackBar
    _showCustomDialog(
      title: 'Point Claimed Successfully!',
      message: 'dont forget to check-in everyday!',
      points: _getPointsForDay(_currentDay),
    );
  }

  // Add this method to handle mission claims with custom dialog
  void _claimMission(int missionIndex, int points) {
    setState(() {
      _currentPoints += points;
      // You can also mark the mission as claimed here
    });

    // Show custom point claimed dialog
    _showCustomDialog(
      title: 'Point Claimed Successfully!',
      message: 'do the other mission to claim more poin and gain more money!',
      points: points,
    );
  }

  // Reusable method for showing custom dialogs
  void _showCustomDialog({
    required String title,
    required String message,
    required int points,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 30),
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 8,
              backgroundColor: Colors.white,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 26.0, vertical: 12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 12),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                        fontFamily: 'Times New Roman',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Text(
                      message,
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B),
                        fontFamily: 'Times New Roman',
                        height: 1.3,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    // Smaller OK button
                    Center(
                      child: SizedBox(
                        width: 100, // Smaller width for the button
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFB8D4E3),
                            foregroundColor: Color(0xFF1E293B),
                            padding: EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: Text(
                            'OK',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Times New Roman',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  int _getPointsForDay(int day) {
    // Updated points to match the image: +2, +3, +5, +5, +7, +8, +10
    List<int> points = [2, 3, 5, 5, 7, 8, 10];
    return points[day];
  }

  // Leaderboard data
  List<Map<String, dynamic>> _getLeaderboardData() {
    return [
      {
        'name': 'Haped Ritswan',
        'education': 'Mahasiswa ITS (Informatika)',
        'description': 'Interested in Robotics engineering.',
        'points': 8500,
        'avatar': '👨‍💻',
        'rank': 1,
      },
      {
        'name': 'Rama Doni Reja',
        'education': 'Mahasiswa ITS (Sistem Informasi)',
        'description':
            'Interested in programming, software development, and robotics.',
        'points': 7200,
        'avatar': '🦆',
        'rank': 2,
      },
      {
        'name': 'Sakiyah Sasmin',
        'education': 'Mahasiswa UGM (Manajemen Bisnis)',
        'description':
            'Interested in business, financial, product management, and startup pitching.',
        'points': 6800,
        'avatar': '🐱',
        'rank': 3,
      },
      {
        'name': 'Ahmad Fauzi',
        'education': 'Mahasiswa UI (Teknik Elektro)',
        'description': 'Passionate about IoT and embedded systems.',
        'points': 6200,
        'avatar': '⚡',
        'rank': 4,
      },
      {
        'name': 'Siti Nurhaliza',
        'education': 'Mahasiswa UB (Ekonomi)',
        'description': 'Interested in digital marketing and e-commerce.',
        'points': 5900,
        'avatar': '💼',
        'rank': 5,
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildTabSelector(),
                  if (_selectedTab == 0) ...[
                    _buildPointsSection(),
                    _buildCheckInSection(),
                    _buildCheckInButton(),
                    _buildMissionList(),
                    _buildLockedSection(),
                  ] else ...[
                    _buildLeaderboardContent(),
                  ],
                  SizedBox(height: 20), // Space for bottom navigation
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      color: Color(0xFF1E293B), // Dark blue background
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
            SizedBox(width: 16),
            Text(
              _selectedTab == 0 ? 'Hadiah Poin' : 'Leaderboard Pengguna',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontFamily: 'Times New Roman',
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabSelector() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Color(0xFFE2E8F0),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTab = 0),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _selectedTab == 0
                      ? Color(
                          0xFF1E293B,
                        ) // Changed from Colors.white to dark background
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: _selectedTab == 0
                      ? null // Removed box shadow for dark background
                      : null,
                ),
                child: Center(
                  child: Text(
                    'Misi Anda',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _selectedTab == 0
                          ? Colors
                                .white // Changed from Color(0xFF1E293B) to white text
                          : Color(0xFF64748B),
                      fontFamily: 'Times New Roman',
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTab = 1),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _selectedTab == 1
                      ? Color(0xFF1E293B)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    'Leaderboard',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _selectedTab == 1
                          ? Colors.white
                          : Color(0xFF64748B),
                      fontFamily: 'Times New Roman',
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

  Widget _buildPointsSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFE2E8F0),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Poin Anda',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF64748B),
                    fontFamily: 'Times New Roman',
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.star, color: Color(0xFFFACC15), size: 20),
                    SizedBox(width: 8),
                    Text(
                      '$_currentPoints',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                        fontFamily: 'Times New Roman',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              _buildActionButton('🎁', 'Reward Box'),
              SizedBox(height: 8),
              _buildActionButton('⭐', 'Top Up Poin'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String emoji, String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: TextStyle(fontSize: 12)),
          SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w500,
              fontFamily: 'Times New Roman',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckInSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Check-in untuk klaim poin',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
              fontFamily: 'Times New Roman',
            ),
          ),
          SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(7, (index) => _buildCheckInDay(index)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckInDay(int dayIndex) {
    // Updated points to match the image: +2, +3, +5, +5, +7, +8, +10
    List<int> points = [2, 3, 5, 5, 7, 8, 10];
    bool isCompleted = dayIndex <= _currentDay;

    return Container(
      width: 55,
      child: Column(
        children: [
          Container(
            width: 50,
            height: 75,
            decoration: BoxDecoration(
              color: Color(0xFF475569), // Dark blue-gray background
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '+${points[dayIndex]}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Times New Roman',
                  ),
                ),
                SizedBox(height: 4),
                Icon(
                  Icons.star,
                  color: Color(0xFFFACC15), // Yellow star
                  size: 24,
                ),
              ],
            ),
          ),
          SizedBox(height: 4),
          Container(
            width: 50,
            padding: EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: dayIndex < 4
                  ? Color(0xFFFACC15)
                  : Color(0xFFE2E8F0), // Yellow for first 4, gray for others
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              dayIndex < 4 ? 'Checked-in' : 'Check-in',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 7,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
                fontFamily: 'Times New Roman',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckInButton() {
    return Container(
      margin: EdgeInsets.only(top: 6, bottom: 16, left: 16, right: 16),
      child: Center(
        child: SizedBox(
          width: 250, // Reduced width
          child: ElevatedButton(
            onPressed: _currentDay < 6 ? _checkIn : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF1E293B),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ), // More rounded
            ),
            child: Text(
              'Check-in untuk hari ini',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: 'Times New Roman',
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMissionList() {
    final missions = [
      {
        'title': 'Login 3 hari berturut-turut',
        'points': 100,
        'progress': 0.6,
        'completed': false,
      },
      {
        'title': 'Login 7 hari berturut-turut',
        'points': 200,
        'progress': 0.3,
        'completed': false,
      },
      {
        'title': 'Bergabung ke 3 course',
        'points': 300,
        'progress': 1.0, // Changed to 100%
        'completed': false, // Will be clickable
      },
      {
        'title': 'Bergabung ke 1 learning group',
        'points': 150,
        'progress': 0.2,
        'completed': false,
      },
    ];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Daftar Misi',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
              fontFamily: 'Times New Roman',
            ),
          ),
          SizedBox(height: 12),
          ...missions.asMap().entries.map((entry) {
            int index = entry.key;
            Map<String, dynamic> mission = entry.value;
            return _buildMissionCard(mission, index);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildMissionCard(Map<String, dynamic> mission, int index) {
    bool isCompleted = mission['progress'] >= 1.0;
    bool canClaim = isCompleted && !mission['completed'];

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Color(0xFF1E293B),
              shape: BoxShape.circle,
            ),
            child: Center(child: Text('🎯', style: TextStyle(fontSize: 20))),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mission['title'],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                    fontFamily: 'Times New Roman',
                  ),
                ),
                SizedBox(height: 8),
                // Add padding to the right to ensure consistent spacing
                Padding(
                  padding: EdgeInsets.only(right: 16), // Add consistent spacing
                  child: Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: Color(0xFFE2E8F0),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: mission['progress'],
                      child: Container(
                        decoration: BoxDecoration(
                          color: isCompleted
                              ? Color(0xFF10B981)
                              : Color(0xFFFACC15),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 4),
                // Moved percentage here next to pts
                Text(
                  '${mission['points']} pts • ${(mission['progress'] * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                    fontFamily: 'Times New Roman',
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: canClaim
                ? () => _claimMission(index, mission['points'])
                : null,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: mission['completed']
                    ? Color(0xFF10B981) // Green for completed
                    : canClaim
                    ? Color(0xFFFACC15) // Yellow for claimable
                    : Color(0xFFE2E8F0), // Gray for not ready
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                mission['completed']
                    ? 'Selesai'
                    : canClaim
                    ? 'Klaim'
                    : 'Klaim',
                style: TextStyle(
                  color: mission['completed'] || canClaim
                      ? Colors.white
                      : Color(0xFF64748B),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Times New Roman',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLockedSection() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF475569),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.lock, color: Colors.white, size: 20),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selesaikan Misi Berbayar',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Times New Roman',
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Dapatkan dengan 100-500 poin untuk menyelesaikan 1-500 poin yang dapat dikumpulkan dengan berbagai misi berbayar.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.8),
                    fontFamily: 'Times New Roman',
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              'Buka Sekarang',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w600,
                fontFamily: 'Times New Roman',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardContent() {
    final leaderboardData = _getLeaderboardData();

    return Container(
      child: Column(
        children: [
          // Podium section
          _buildPodium(leaderboardData.take(3).toList()),

          // Leaderboard Detail section
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Color(0xFFB8D4E3),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Text(
                    'Leaderboard Detail',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF1E293B),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Times New Roman',
                    ),
                  ),
                ),
                SizedBox(height: 16),
                ...leaderboardData
                    .map((user) => _buildLeaderboardCard(user))
                    .toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPodium(List<Map<String, dynamic>> topThree) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      height: 200,
      child: Stack(
        children: [
          // Background podium
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // 2nd place podium
                Container(
                  width: 80,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Color(0xFF64748B),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '2',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                // 1st place podium
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Color(0xFFFACC15),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '1',
                      style: TextStyle(
                        color: Color(0xFF1E293B),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                // 3rd place podium
                Container(
                  width: 80,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Color(0xFF94A3B8),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '3',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // User avatars
          Positioned(
            bottom: 60,
            left: 40,
            child: _buildPodiumAvatar(topThree[1]['avatar'], 95), // 2nd place
          ),
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Center(
              child: _buildPodiumAvatar(
                topThree[0]['avatar'],
                110,
              ), // 1st place
            ),
          ),
          Positioned(
            bottom: 40,
            right: 40,
            child: _buildPodiumAvatar(topThree[2]['avatar'], 90), // 3rd place
          ),
        ],
      ),
    );
  }

  Widget _buildPodiumAvatar(String avatar, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Color(0xFFE2E8F0),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
      ),
      child: Center(
        child: Text(avatar, style: TextStyle(fontSize: size * 0.4)),
      ),
    );
  }

  Widget _buildLeaderboardCard(Map<String, dynamic> user) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Color(0xFFE2E8F0),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(user['avatar'], style: TextStyle(fontSize: 20)),
            ),
          ),
          SizedBox(width: 16),
          // User info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user['name'],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                    fontFamily: 'Times New Roman',
                  ),
                ),
                SizedBox(height: 4),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    user['education'],
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                      fontFamily: 'Times New Roman',
                    ),
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  user['description'],
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                    fontFamily: 'Times New Roman',
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          // Rank
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: user['rank'] <= 3 ? Color(0xFFFACC15) : Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              '#${user['rank']}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: user['rank'] <= 3
                    ? Color(0xFF1E293B)
                    : Color(0xFF64748B),
                fontFamily: 'Times New Roman',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF1E293B),
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
              _buildNavItem(Icons.smart_toy_outlined, 'ChampBot', 3),
              _buildNavItem(Icons.school_outlined, 'Mentor', 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isSelected = _selectedIndex == index;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _onItemTapped(index),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? Color(0xFF334155) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : Color(0xFF94A3B8),
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
      ),
    );
  }
}
