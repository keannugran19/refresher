import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:refresher/constants/color_scheme.dart';
import 'package:refresher/services/event_service.dart';
import 'package:refresher/views/events/edit_event_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventDetailsScreen extends StatefulWidget {
  final int eventId;
  final int userId;

  const EventDetailsScreen({
    super.key,
    required this.eventId,
    required this.userId,
  });

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  late Map<String, dynamic> event;

  bool isOwner = false;

  // check user ownership of event
  Future<void> _checkOwnership() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    int? currentUserId = prefs.getInt('user_id');

    if (token == null ||
        currentUserId == null ||
        currentUserId != widget.userId) {
      setState(() {
        isOwner = false;
      });
    } else {
      setState(() {
        isOwner = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _checkOwnership();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: primaryFgColor,
        actions: [
          if (isOwner)
            // edit button
            IconButton(onPressed: _editEvent, icon: Icon(Icons.edit)),
          if (isOwner)
            // delete button
            IconButton(onPressed: _deleteDialog, icon: Icon(Icons.delete)),
        ],
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: EventService.fetchEvent(widget.eventId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else {
              final event = snapshot.data!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // event title section
                  _eventTitle(event['title']),
                  // other information section
                  _otherEventInfo(
                    event['description'],
                    event['location'],
                    formatDate(event['date']),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  // refresh event when successfully updated
  Future<void> _loadEvent() async {
    final event = await EventService.fetchEvent(widget.eventId);
    setState(() {
      this.event = event;
    });
  }

  // format date
  String formatDate(String mysqlDate) {
    DateTime date = DateTime.parse(mysqlDate);
    return DateFormat('MMMM d, y').format(date);
  }

  // go to edit screen
  Future<void> _editEvent() async {
    final updated = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditEventScreen(eventId: widget.eventId),
      ),
    );

    if (updated == true) {
      _loadEvent();
    }
  }

  // confirm deletion dialog
  Future<String?> _deleteDialog() => showDialog<String>(
    context: context,
    builder:
        (BuildContext context) => AlertDialog(
          title: const Text('Delete event?'),
          content: const Text('Are you sure? This cannot be undone!'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final deleted = await EventService.deleteEvent(widget.eventId);
                if (deleted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Event successfully deleted"),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Failed to delete event"),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
                Navigator.pushNamed(context, 'event_list_screen');
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
  );

  Widget _eventTitle(String eventTitle) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: primaryColor),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 4,
          children: [
            Icon(Icons.event, size: 90.0, color: primaryFgColor),
            Text(
              eventTitle,
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

  Widget _otherEventInfo(
    String eventDescription,
    String eventLocation,
    String eventDate,
  ) {
    final double fontSize = 16;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          // about
          Text(
            'About Event',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize),
          ),
          Text(eventDescription),
          SizedBox(height: 10),
          // location
          Text(
            'Location',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize),
          ),
          Text(eventLocation),
          SizedBox(height: 10),
          // date
          Text(
            'Date',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize),
          ),
          Text(eventDate),
        ],
      ),
    );
  }
}
