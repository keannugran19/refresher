import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:refresher/components/event_card.dart';
import 'package:refresher/constants/color_scheme.dart';
import 'package:refresher/views/events/event_details_screen.dart';

class EventListScreen extends StatefulWidget {
  const EventListScreen({super.key});

  @override
  State<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
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
        onRefresh: () async {
          // Replace this delay with the code to be executed during refresh
          // and return asynchronous code
          return Future<void>.delayed(const Duration(seconds: 3));
        },
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: <Widget>[
            // event cards
            EventCardWidget(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => const EventDetailsScreen(
                          eventTitle: 'Thanksgiving Ceremony',
                          eventDate: 'April 28, 2025',
                          eventDescription:
                              'We invite you to come to TIFMOROLI 15th thanksgiving! We are encouraging everyone to wear family of blue!',
                          eventLocation: 'Prk. Kalubihan, Panabo City',
                        ),
                  ),
                );
              },
              eventTitle: 'Thanksgiving Ceremony',
              eventDescription:
                  'We invite you to come to TIFMOROLI 15th thanksgiving! We are encouraging everyone to wear family of blue!',
              eventDate: 'April 28, 2025',
              eventLocation: 'Prk. Kalubihan, Panabo City',
            ),
          ],
        ),
      ),
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
}
