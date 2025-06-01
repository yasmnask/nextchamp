import 'package:flutter/material.dart';
import 'package:nextchamp/models/user_model.dart';
import 'package:nextchamp/core/secure_storage.dart';

class ProfileSection extends StatefulWidget {
  @override
  _ProfileSectionState createState() => _ProfileSectionState();
}

class _ProfileSectionState extends State<ProfileSection> {
  User? _user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await SecureStorage.getUser();
    setState(() {
      _user = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _user?.fullname ?? 'Loading...',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: 'Times New Roman',
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          'Level 3', // ini kalau level ada di user, bisa ganti jadi _user?.level ?? 'Level 3'
          style: TextStyle(
            color: Color(0xFFE2E8F0),
            fontSize: 14,
            fontFamily: 'poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
