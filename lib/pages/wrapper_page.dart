import 'package:flutter/material.dart';
import 'package:nextchamp/components/bottom_navigation.dart';
import 'package:nextchamp/pages/login_page.dart';
import 'package:nextchamp/providers/user_provider.dart';
import 'package:provider/provider.dart';

class WrapperPage extends StatefulWidget {
  const WrapperPage({super.key});

  @override
  State<WrapperPage> createState() => _WrapperPageState();
}

class _WrapperPageState extends State<WrapperPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeUser();
  }

  Future<void> _initializeUser() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.loadUser();

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _buildLoadingScreen();
    }

    final user = Provider.of<UserProvider>(context).user;
    return user == null ? const LoginPage() : const BottomNavigation();
  }

  Scaffold _buildLoadingScreen() {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(15),
                child: Image.asset(
                  'assets/logo_nextchamp.png',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 24),

              // App name
              const Text(
                'NextChamp',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2D3B4E),
                ),
              ),
              const SizedBox(height: 40),

              // Simple loading indicator
              SizedBox(
                width: 36,
                height: 36,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    const Color(0xFF4A80F0),
                  ),
                  backgroundColor: Colors.grey.withOpacity(0.1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
