import 'package:flutter/material.dart';
import 'package:refresher/constants/color_scheme.dart';
import 'package:refresher/views/events/edit_event_screen.dart';

class EventDetailsScreen extends StatelessWidget {
  final String eventTitle;
  final String eventDescription;
  final String eventDate;
  final String eventLocation;
  const EventDetailsScreen({
    super.key,
    required this.eventTitle,
    required this.eventDescription,
    required this.eventDate,
    required this.eventLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: primaryFgColor,
        actions: [
          // edit button
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditEventScreen()),
              );
            },
            icon: Icon(Icons.edit),
          ),
          // delete button
          IconButton(
            onPressed:
                () => showDialog<String>(
                  context: context,
                  builder:
                      (BuildContext context) => AlertDialog(
                        title: const Text('Delete event?'),
                        content: const Text(
                          'Are you sure? This cannot be undone!',
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'Cancel'),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'OK'),
                            child: const Text(
                              'Delete',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                ),
            icon: Icon(Icons.delete),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // event title section
            _eventTitle(),
            // other information section
            _otherEventInfo(),
          ],
        ),
      ),
    );
  }

  Widget _eventTitle() {
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

  Widget _otherEventInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          // about
          Text(
            'About Event',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(eventDescription),
          SizedBox(height: 10),
          // location
          Text(
            'Location',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(eventLocation),
          SizedBox(height: 10),
          // date
          Text(
            'Date',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(eventDate),
        ],
      ),
    );
  }
}
