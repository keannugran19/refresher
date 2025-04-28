import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  @override
  Widget build(BuildContext context) {
    // logout functionality
    void logout() async {
      await FirebaseAuth.instance.signOut();

      if (context.mounted) {
        Navigator.pushNamed(context, 'landing_page');
      }
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: logout,
            icon: Icon(Icons.account_circle_outlined),
          ),
        ],
        title: Text("Hola!"),
      ),
      body: Center(child: Text("You are successfully logged in")),
    );
  }
}
