import 'package:flutter/material.dart';
import 'package:refresher/views/auth/login_page.dart';
import 'package:refresher/views/auth/register_page.dart';

class LandingPageView extends StatefulWidget {
  const LandingPageView({super.key});

  @override
  State<LandingPageView> createState() => _LandingPageViewState();
}

class _LandingPageViewState extends State<LandingPageView> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          appBar: TabBar(
            tabs: [Tab(text: 'Login'), Tab(text: 'Register')],
            dividerHeight: 1,
          ),
          body: const TabBarView(
            children: [LoginPageView(), RegisterPageView()],
          ),
        ),
      ),
    );
  }
}
