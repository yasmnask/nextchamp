import 'package:flutter/material.dart';
import 'package:nextchamp/providers/user_provider.dart';
import 'package:nextchamp/utils/string_utils.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ProfileSection extends StatefulWidget {
  const ProfileSection({super.key});

  @override
  _ProfileSectionState createState() => _ProfileSectionState();
}

class _ProfileSectionState extends State<ProfileSection> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.user;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        user != null
            ? Text(
                StringUtils.capitalizeWords(
                  user != null ? StringUtils.ellipsize(user.fullname, 13) : '',
                ),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'Times New Roman',
                  fontWeight: FontWeight.w600,
                ),
              )
            : Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(width: 100, height: 20, color: Colors.white),
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
