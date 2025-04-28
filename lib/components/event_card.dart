import 'package:flutter/material.dart';

class EventCardWidget extends StatelessWidget {
  final String eventTitle;
  final String eventDescription;
  final String eventDate;
  final String eventLocation;
  final Function() onTap;

  const EventCardWidget({
    super.key,
    required this.eventTitle,
    required this.eventDescription,
    required this.eventDate,
    required this.onTap,
    required this.eventLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            spacing: 6,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // title of event
              Text(
                eventTitle,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              // description of the event
              Text(
                eventDescription,
                style: TextStyle(fontSize: 12),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              // date of event & location
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    eventDate,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  Text(
                    eventLocation,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
