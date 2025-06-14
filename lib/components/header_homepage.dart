import 'package:flutter/material.dart';
import 'package:nextchamp/pages/login_page.dart';
import 'package:nextchamp/providers/user_provider.dart';
import 'package:nextchamp/services/auth_service.dart';
import 'package:nextchamp/utils/string_utils.dart';
import 'package:nextchamp/widgets/custom_toast.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:toastification/toastification.dart';

class HeaderHomepage extends StatefulWidget {
  const HeaderHomepage({super.key});

  @override
  State<HeaderHomepage> createState() => _HeaderHomepageState();
}

class _HeaderHomepageState extends State<HeaderHomepage> {
  final _authService = AuthService();

  void _handleMenuSelection(String value, UserProvider userProvider) {
    switch (value) {
      case 'edit_profile':
        _showEditProfileDialog();
        break;
      case 'logout':
        _showLogoutDialog(userProvider);
        break;
    }
  }

  // Method to show edit profile dialog
  void _showEditProfileDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.edit, color: Color(0xFF334155)),
              SizedBox(width: 8),
              Text(
                'Edit Profile',
                style: TextStyle(
                  color: Color(0xFF334155),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Text(
            'Edit profile functionality will be implemented here.',
            style: TextStyle(color: Color(0xFF64748B), fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel', style: TextStyle(color: Color(0xFF64748B))),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // TODO: Navigate to edit profile page
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF8FA2B7),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('Edit', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  // Method to show logout confirmation dialog
  void _showLogoutDialog(UserProvider userProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.logout, color: Color(0xFFEF4444)),
              SizedBox(width: 8),
              Text(
                'Log Out',
                style: TextStyle(
                  color: Color(0xFF334155),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to log out?',
            style: TextStyle(color: Color(0xFF64748B), fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel', style: TextStyle(color: Color(0xFF64748B))),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _performLogout(userProvider);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFEF4444),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('Log Out', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _performLogout(UserProvider userProvider) async {
    await _authService.logout(userProvider);

    if (!mounted) return;

    CustomToast.show(
      context,
      title: 'Success',
      message: 'Anda Berhasil Logout!',
      type: ToastificationType.success,
    );

    // Navigasi ke halaman login (clear all previous routes)
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.user;

    return Padding(
      padding: EdgeInsets.fromLTRB(24, 16, 24, 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // Replace the static Icon with PopupMenuButton
              PopupMenuButton<String>(
                icon: Icon(Icons.settings, color: Colors.white, size: 24),
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                offset: Offset(0, 40), // Position dropdown below the icon
                onSelected: (String value) {
                  _handleMenuSelection(value, userProvider);
                },
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem<String>(
                    value: 'edit_profile',
                    child: Row(
                      children: [
                        Icon(Icons.edit, color: Color(0xFF334155), size: 20),
                        SizedBox(width: 12),
                        Text(
                          'Edit Profile',
                          style: TextStyle(
                            color: Color(0xFF334155),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'logout',
                    child: Row(
                      children: [
                        Icon(Icons.logout, color: Color(0xFFEF4444), size: 20),
                        SizedBox(width: 12),
                        Text(
                          'Log Out',
                          style: TextStyle(
                            color: Color(0xFFEF4444),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(width: 12),
              user != null
                  ? Text(
                      'Welcome, ${StringUtils.capitalizeWords(user.username)}!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  : Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: 100,
                        height: 20,
                        color: Colors.white,
                      ),
                    ),
            ],
          ),
          Icon(Icons.notifications_outlined, color: Colors.white, size: 24),
        ],
      ),
    );
  }
}
