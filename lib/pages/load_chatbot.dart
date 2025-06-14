import 'package:flutter/material.dart';
import 'dart:async';
import 'chatbot_screen.dart'; // Import the new chatbot screen

class LoadChatbotScreen extends StatefulWidget {
  @override
  _LoadChatbotScreenState createState() => _LoadChatbotScreenState();
}

class _LoadChatbotScreenState extends State<LoadChatbotScreen>
    with TickerProviderStateMixin {
  late AnimationController _robotAnimationController;
  late AnimationController _loadingAnimationController;
  late Animation<double> _robotAnimation;
  late Animation<double> _loadingAnimation;

  @override
  void initState() {
    super.initState();
    
    // Robot animation controller
    _robotAnimationController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    
    // Loading dots animation controller
    _loadingAnimationController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    _robotAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _robotAnimationController,
      curve: Curves.elasticOut,
    ));

    _loadingAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_loadingAnimationController);

    // Start animations
    _robotAnimationController.forward();
    _loadingAnimationController.repeat();

    // Navigate to chatbot after 4 seconds
    Timer(Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ChatbotScreen()), // Updated to use new ChatbotScreen
      );
    });
  }

  @override
  void dispose() {
    _robotAnimationController.dispose();
    _loadingAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Champ Bot',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Color(0xFF2C3E50),
        elevation: 0,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 18,
              child: ClipOval(
                child: Image.asset(
                  'assets/kepala_bot.png',
                  width: 32,
                  height: 32,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.smart_toy,
                      color: Color(0xFF2C3E50),
                      size: 20,
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Color(0xFFF8F9FA),
              Color(0xFFE3F2FD).withOpacity(0.3),
            ],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animated Robot - using placeholder for now
                    AnimatedBuilder(
                      animation: _robotAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _robotAnimation.value,
                          child: Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFFFF8E1).withOpacity(0.5),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue.withOpacity(0.2),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Image.asset(
                                'assets/bot_icon.png',
                                width: 150,
                                height: 150,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  print('Error loading bot_icon.png: $error');
                                  return _buildRobotPlaceholder();
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    
                    SizedBox(height: 30),
                    
                    // Loading text
                    Text(
                      'Initializing Champ Bot...',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                    
                    SizedBox(height: 10),
                    
                    Text(
                      'Your assistant to Win like a Champ!',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF7F8C8D),
                      ),
                    ),
                    
                    SizedBox(height: 30),
                    
                    // Loading dots animation
                    AnimatedBuilder(
                      animation: _loadingAnimation,
                      builder: (context, child) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(3, (index) {
                            double delay = index * 0.3;
                            double animationValue = (_loadingAnimation.value - delay).clamp(0.0, 1.0);
                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 4),
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF3498DB).withOpacity(
                                  0.3 + (0.7 * animationValue),
                                ),
                              ),
                            );
                          }),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            
            // Bottom Navigation Bar
            Container(
              height: 70,
              decoration: BoxDecoration(
                color: Color(0xFF2C3E50),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavItem(Icons.people, 'Profile'),
                  _buildNavItem(Icons.language, 'Global'),
                  _buildNavItem(Icons.home, 'Home'),
                  _buildNavItem(Icons.visibility, 'Discover'),
                  _buildNavItem(Icons.chat_bubble, 'Chat', isActive: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRobotPlaceholder() {
    return Container(
      width: 150,
      height: 150,
      child: Stack(
        children: [
          // Box
          Positioned(
            bottom: 20,
            left: 25,
            right: 25,
            height: 80,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.brown.shade400,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.brown.shade600,
                    offset: Offset(0, 4),
                    blurRadius: 8,
                  ),
                ],
              ),
            ),
          ),
          // Robot head
          Positioned(
            top: 20,
            left: 35,
            right: 35,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Color(0xFF3498DB), width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Center(
                child: Container(
                  width: 35,
                  height: 15,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ),
          // Robot arms
          Positioned(
            top: 70,
            left: 15,
            child: Container(
              width: 15,
              height: 35,
              decoration: BoxDecoration(
                color: Color(0xFF3498DB),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          Positioned(
            top: 70,
            right: 15,
            child: Container(
              width: 15,
              height: 35,
              decoration: BoxDecoration(
                color: Color(0xFF3498DB),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, {bool isActive = false}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: isActive ? Color(0xFF3498DB) : Colors.white,
          size: 24,
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isActive ? Color(0xFF3498DB) : Colors.white,
            fontSize: 10,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
