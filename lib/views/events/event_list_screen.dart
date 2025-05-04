import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:refresher/components/animated_route.dart';
import 'package:refresher/components/event_card.dart';
import 'package:refresher/constants/color_scheme.dart';
import 'package:refresher/services/auth_service.dart';
import 'package:refresher/services/event_service.dart';
import 'package:refresher/views/auth/user_profile.dart';
import 'package:refresher/views/events/create_event_screen.dart';
import 'package:refresher/views/events/event_details_screen.dart';
import 'package:refresher/views/landing_page.dart';

class EventListScreen extends StatefulWidget {
  const EventListScreen({super.key});

  @override
  State<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  Future<List<dynamic>>? _events;
  // check if user is authenticated
  bool isAuthenticated = false;
  // search controller
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _events = EventService.fetchEvents();
    _checkAuthStatus();
  }

  @override
  void dispose() {
    super.dispose();
    searchController;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
        backgroundColor: primaryColor,
        foregroundColor: primaryFgColor,
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            onPressed: isAuthenticated == false ? _login : _userProfile,
            icon: Icon(Icons.account_circle_outlined),
          ),
        ],
        title: Text(
          "refresher",
          style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: _searchField(),
        ),
      ),
      body: RefreshIndicator(
        color: accentColor,
        backgroundColor: accentFgColor,
        onRefresh: _refreshEvents,
        child: FutureBuilder<List<dynamic>>(
          future: _events,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error loading products"));
            }
            // else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            //   return hasNoData();
            // }
            else {
              final events = snapshot.data!;
              return ListView.builder(
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final event = events[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: EventCardWidget(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => EventDetailsScreen(
                                  eventId: event['id'],
                                  userId: event['user_id'],
                                ),
                          ),
                        );
                      },
                      eventTitle: event["title"],
                      eventDescription: event['description'],
                      eventDate: formatDate(event['date']),
                      eventLocation: event['location'],
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton:
          isAuthenticated == false ? Container() : _floatingActionButton(),
    );
  }

  // build search widget
  Widget _searchField() {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 16),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search),
          filled: true,
          fillColor: primaryFgColor,
          hintText: 'Search events...',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(100)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
            borderSide: BorderSide(color: secondaryColor, width: 2),
          ),
        ),
        onSubmitted: (value) => _searchEvents(value),
      ),
    );
  }

  // search function
  Future<void> _searchEvents(String query) async {
    final data = await EventService.searchEvents(query);

    setState(() {
      _events = Future.value(data);
    });
  }

  // redirect to user profile
  void _userProfile() {
    Navigator.push(
      context,
      AnimatedRoute(widget: UserProfileScreen(), offset: Offset(1.0, 0.0)),
    );
  }

  void _login() {
    Navigator.pushReplacement(
      context,
      AnimatedRoute(widget: LandingPageView(), offset: Offset(-1.0, 0.0)),
    );
  }

  // check if user is authenticated
  Future<void> _checkAuthStatus() async {
    bool isAuth = await AuthService.isAuthenticated();

    if (isAuth) {
      setState(() {
        isAuthenticated = true;
      });
    }
  }

  // refresh events
  Future<void> _refreshEvents() async {
    setState(() {
      _events = EventService.fetchEvents();
      searchController.text = '';
    });
  }

  // display this widget when there is no data
  // Widget hasNoData() {
  //   return Center(
  //     child: Column(
  //       spacing: 20,
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         SvgPicture.asset('assets/svg/no-data.svg', height: 150, width: 150),
  //         const Text(
  //           "No Events",
  //           style: TextStyle(
  //             fontSize: 20,
  //             color: primaryColor,
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // format date
  String formatDate(String mysqlDate) {
    DateTime date = DateTime.parse(mysqlDate);
    return DateFormat('MMMM d, y').format(date);
  }

  Widget _floatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          AnimatedRoute(widget: CreateEventScreen(), offset: Offset(0.0, 1.0)),
        );
      },
      child: Icon(Icons.create),
    );
  }
}
