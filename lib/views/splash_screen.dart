import 'package:flutter/material.dart';
import 'package:refresher/services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    bool isAuth = await AuthService.isAuthenticated();

    if (isAuth) {
      Navigator.pushReplacementNamed(context, 'event_list_screen');
    } else {
      Navigator.pushReplacementNamed(context, 'landing_page');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Center(child: CircularProgressIndicator())),
    );
  }
}
