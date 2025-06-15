import 'package:flutter/material.dart';
import 'package:nextchamp/providers/bottom_navigation_provider.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'champbot_page.dart'; // Import the new chatbot screen - assuming this path is correct

class LoadChatbotPage extends StatefulWidget {
  @override
  _LoadChatbotPageState createState() => _LoadChatbotPageState();
}

class _LoadChatbotPageState extends State<LoadChatbotPage>
    with TickerProviderStateMixin {
  // Animation controller for the robot's entrance
  late AnimationController _robotEntranceController;
  // Animation for the robot's scale effect
  late Animation<double> _robotScaleAnimation;

  // Animation controller for the loading dots
  late AnimationController _loadingDotsController;
  // Animation for the loading dots' pulsating effect
  late Animation<double> _loadingDotsAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize robot entrance animation controller
    _robotEntranceController = AnimationController(
      duration: const Duration(seconds: 1), // Shorter, snappier entrance
      vsync: this,
    );

    // Define the robot scale animation with a bouncy curve
    _robotScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _robotEntranceController,
        curve: Curves.elasticOut, // More pronounced elastic effect
      ),
    );

    // Initialize loading dots animation controller
    _loadingDotsController = AnimationController(
      duration: const Duration(milliseconds: 1000), // Faster, continuous pulse
      vsync: this,
    );

    // Define the loading dots animation for a fade/scale effect
    _loadingDotsAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_loadingDotsController);

    // Start animations
    _robotEntranceController.forward(); // Start robot entrance animation
    _loadingDotsController.repeat(
      reverse: true,
    ); // Repeat dots animation with reverse for pulsating effect

    // Timer to navigate to the chatbot page after a delay
    Timer(const Duration(seconds: 2), () {
      // Ensure the widget is still mounted before attempting navigation
      if (mounted) {
        context.read<BottomNavigationProvider>().setPage(3);
      }
    });
  }

  @override
  void dispose() {
    // Dispose of animation controllers to prevent memory leaks
    _robotEntranceController.dispose();
    _loadingDotsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Champ Bot',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: const Color(0xFF2C3E50), // Dark blue-grey
        elevation: 0, // No shadow for a flat design
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 18,
              child: ClipOval(
                child: Image.asset(
                  'assets/kepala_bot.png', // Image for the app bar avatar
                  width: 32,
                  height: 32,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback icon if image fails to load
                    return const Icon(
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
              const Color(0xFFF8F9FA), // Light grey
              const Color(
                0xFFE3F2FD,
              ).withOpacity(0.5), // Lighter blue with more opacity
            ],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  // Added for better handling of small screens
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 40.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Animated Robot - using placeholder if image fails
                      AnimatedBuilder(
                        animation: _robotScaleAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _robotScaleAnimation
                                .value, // Apply scaling animation
                            child: Container(
                              width: 220, // Slightly larger container
                              height: 220, // Slightly larger container
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(
                                  0xFFFFF8E1,
                                ).withOpacity(0.6), // Softer background color
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blue.withOpacity(
                                      0.3,
                                    ), // More pronounced blue shadow
                                    blurRadius: 30, // Increased blur
                                    spreadRadius: 8, // Increased spread
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Image.asset(
                                  'assets/bot_icon.png', // Main robot icon
                                  width: 160, // Slightly larger image
                                  height: 160, // Slightly larger image
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    debugPrint(
                                      'Error loading bot_icon.png: $error',
                                    );
                                    return _buildRobotPlaceholder(); // Fallback placeholder
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 40), // Increased spacing
                      // Loading title text
                      const Text(
                        'Initializing Champ Bot...',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22, // Larger font size for prominence
                          fontWeight: FontWeight.w700, // Bolder font weight
                          color: Color(0xFF2C3E50), // Dark blue-grey
                          letterSpacing: 0.5, // Subtle letter spacing
                        ),
                      ),

                      const SizedBox(height: 15), // Increased spacing
                      // Subtitle text
                      const Text(
                        'Your intelligent assistant to Win like a Champ!', // Slightly rephrased
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16, // Slightly larger
                          color: Color(0xFF7F8C8D), // Grey
                          fontStyle:
                              FontStyle.italic, // Italic for a softer feel
                        ),
                      ),

                      const SizedBox(height: 40), // Increased spacing
                      // Loading dots animation
                      AnimatedBuilder(
                        animation: _loadingDotsAnimation,
                        builder: (context, child) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(3, (index) {
                              // Calculate animation value for each dot, creating a wave effect
                              final double dotAnimationValue =
                                  (_loadingDotsAnimation.value +
                                      (index * 0.2) // Stagger the animation
                                      ) %
                                  1.0; // Ensure value loops from 0 to 1

                              // Determine dot scale and opacity based on animation value
                              final double scale =
                                  0.8 +
                                  (0.4 * dotAnimationValue); // Pulsating scale
                              final double opacity =
                                  0.4 +
                                  (0.6 *
                                      dotAnimationValue); // Pulsating opacity

                              return Transform.scale(
                                scale: scale,
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                  ), // More space between dots
                                  width: 14, // Slightly larger dot size
                                  height: 14,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: const Color(0xFF3498DB).withOpacity(
                                      opacity,
                                    ), // Blue with animated opacity
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
            ),
          ],
        ),
      ),
    );
  }

  // Placeholder widget for the robot if image asset fails to load
  Widget _buildRobotPlaceholder() {
    return Container(
      width: 160, // Match image size for consistent container
      height: 160,
      child: Stack(
        alignment: Alignment.center, // Center the placeholder elements
        children: [
          // Robot body (simulated as a rounded rectangle)
          Positioned(
            bottom: 30, // Adjusted position
            child: Container(
              width: 100,
              height: 90, // Taller body
              decoration: BoxDecoration(
                color: Colors.grey.shade700, // Darker grey for body
                borderRadius: BorderRadius.circular(12), // More rounded corners
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    offset: const Offset(0, 6),
                    blurRadius: 10,
                  ),
                ],
              ),
            ),
          ),
          // Robot head (simulated as a circle)
          Positioned(
            top: 25, // Adjusted position
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF3498DB),
                  width: 4,
                ), // Thicker border
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Center(
                // Robot 'eye' or 'screen'
                child: Container(
                  width: 45,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10), // More rounded
                  ),
                ),
              ),
            ),
          ),
          // Robot arms (simulated as rounded rectangles)
          Positioned(
            top: 75, // Aligned with body
            left: 20, // Further out
            child: Container(
              width: 20,
              height: 45, // Longer arms
              decoration: BoxDecoration(
                color: const Color(0xFF3498DB), // Blue arms
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    offset: const Offset(2, 2),
                    blurRadius: 5,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 75,
            right: 20,
            child: Container(
              width: 20,
              height: 45,
              decoration: BoxDecoration(
                color: const Color(0xFF3498DB),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    offset: const Offset(-2, 2),
                    blurRadius: 5,
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
