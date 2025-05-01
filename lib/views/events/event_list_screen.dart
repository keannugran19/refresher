import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:refresher/components/event_card.dart';
import 'package:refresher/constants/color_scheme.dart';
import 'package:refresher/services/auth_service.dart';
import 'package:refresher/services/event_service.dart';
import 'package:refresher/views/events/event_details_screen.dart';

class EventListScreen extends StatefulWidget {
  const EventListScreen({super.key});

  @override
  State<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  Future<List<dynamic>>? _events;
  // check if user is authenticated
  bool isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _events = EventService.fetchEvents();
    _checkAuthStatus();
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
            onPressed: logout,
            icon: Icon(Icons.account_circle_outlined),
          ),
        ],
        title: Text("Hola!"),
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
            } else {
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
                                (_) => EventDetailsScreen(eventId: event['id']),
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
      child: SearchAnchor(
        isFullScreen: false,
        viewHintText: 'Search Event',
        builder: (BuildContext context, SearchController controller) {
          return SearchBar(
            hintText: 'Search Event',
            controller: controller,
            padding: const WidgetStatePropertyAll<EdgeInsets>(
              EdgeInsets.symmetric(horizontal: 16.0),
            ),
            onTap: () {
              controller.openView();
            },
            onChanged: (_) {
              controller.openView();
            },
            leading: const Icon(Icons.search),
            trailing: <Widget>[],
          );
        },
        suggestionsBuilder: (
          BuildContext context,
          SearchController controller,
        ) {
          return List<ListTile>.generate(5, (int index) {
            final String item = 'item $index';
            return ListTile(
              title: Text(item),
              onTap: () {
                setState(() {
                  controller.closeView(item);
                });
              },
            );
          });
        },
      ),
    );
  }

  // logout functionality
  void logout() async {
    await AuthService.logout();

    if (context.mounted) {
      Navigator.pushReplacementNamed(context, 'landing_page');
    }
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
    });
  }

  // format date
  String formatDate(String mysqlDate) {
    DateTime date = DateTime.parse(mysqlDate);
    return DateFormat('MMMM d, y').format(date);
  }

  Widget _floatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.pushNamed(context, 'create_event_screen');
      },
      child: Icon(Icons.create),
    );
  }
}
