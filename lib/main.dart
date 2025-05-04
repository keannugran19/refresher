import 'package:flutter/material.dart';
import 'package:refresher/constants/theme_data.dart';
import 'package:refresher/views/auth/login_page.dart';
import 'package:refresher/views/auth/register_page.dart';
import 'package:refresher/views/auth/user_profile.dart';
import 'package:refresher/views/events/create_event_screen.dart';
import 'package:refresher/views/events/event_list_screen.dart';
import 'package:refresher/views/landing_page.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: 'event_list_screen',
      routes: {
        'user_profile_screen': (context) => UserProfileScreen(),
        'login_page': (context) => LoginPageView(),
        'registration_page': (context) => RegisterPageView(),
        'event_list_screen': (context) => EventListScreen(),
        'landing_page': (context) => LandingPageView(),
        'create_event_screen': (context) => CreateEventScreen(),
      },
      debugShowCheckedModeBanner: false,
      title: 'Refresher',
      theme: ThemeClass.theme,
    );
  }
}
