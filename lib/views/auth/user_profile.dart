import 'package:flutter/material.dart';
import 'package:refresher/constants/color_scheme.dart';
import 'package:refresher/services/auth_service.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: primaryFgColor,
        actions: [
          // logout button
          IconButton(
            onPressed: _logout,
            icon: Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: FutureBuilder(
        future: AuthService.getUserInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            final userInfo = snapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // header section
                _userNameHeader(userInfo['name']),
                // other information section
                _otherUserInfo(userInfo['email']),
              ],
            );
          }
        },
      ),
    );
  }

  // confirm logout dialog
  Future<String?> _logout() async {
    showDialog<String>(
      context: context,
      builder:
          (BuildContext context) => AlertDialog(
            title: const Text('Logout?'),
            content: const Text('Are you sure you want to logout?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  final result = await AuthService.logout();

                  if (result['success'] == true) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(result['message']),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.pushReplacementNamed(context, 'landing_page');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(result['message']),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
    return null;
  }

  Widget _userNameHeader(String userName) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: primaryColor),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 4,
          children: [
            Icon(
              Icons.account_circle_rounded,
              size: 90.0,
              color: primaryFgColor,
            ),
            Text(
              userName,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.fade,
              style: TextStyle(
                color: primaryFgColor,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _otherUserInfo(String userEmail) {
    final double fontSize = 16;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          // about
          Text(
            'Email',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize),
          ),
          Text(userEmail),
        ],
      ),
    );
  }
}
