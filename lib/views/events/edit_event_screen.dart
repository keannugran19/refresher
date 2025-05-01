import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:refresher/constants/color_scheme.dart';
import 'package:refresher/services/event_service.dart';

class EditEventScreen extends StatefulWidget {
  final int eventId;
  const EditEventScreen({super.key, required this.eventId});

  @override
  State<EditEventScreen> createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  // form key
  final _formKey = GlobalKey<FormState>();

  // loading
  bool isLoading = true;

  // textfield controllers
  late TextEditingController eventTitleController;
  late TextEditingController eventDescriptionController;
  late TextEditingController eventLocationController;
  late TextEditingController eventDateController;

  // selectdate var
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    eventTitleController = TextEditingController();
    eventDescriptionController = TextEditingController();
    eventLocationController = TextEditingController();
    eventDateController = TextEditingController();
    _loadEvent();
  }

  Future<void> _loadEvent() async {
    final event = await EventService.fetchEvent(widget.eventId);
    setState(() {
      eventTitleController.text = event['title'];
      eventDescriptionController.text = event['description'];
      eventLocationController.text = event['location'];
      selectedDate = DateTime.parse(event['date']);
      isLoading = false;
    });
  }

  // reusable outline input border
  OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
  );

  // column spacing and padding
  final double cpSpace = 20;

  @override
  void dispose() {
    eventTitleController.dispose();
    eventDescriptionController.dispose();
    eventLocationController.dispose();
    eventDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Center(child: CircularProgressIndicator());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: primaryFgColor,
        actions: [
          // create button
          IconButton(onPressed: _editEvent, icon: Icon(Icons.edit)),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // create new event header
              _editEventHeader(),
              // event title field
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: cpSpace,
                  vertical: cpSpace,
                ),
                child: Column(
                  spacing: cpSpace,
                  children: [
                    TextFormField(
                      controller: eventTitleController,
                      decoration: InputDecoration(
                        border: outlineInputBorder,
                        hintText: 'Enter event title...',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                    ),
                    // event description field
                    TextFormField(
                      controller: eventDescriptionController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        border: outlineInputBorder,
                        hintText: 'Enter event description...',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                    ),
                    // event date picker
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        title: Text(
                          selectedDate == null
                              ? "Pick a date"
                              : "Date: ${DateFormat('MMMM d, y').format(selectedDate!)}",
                        ),
                        trailing: Icon(Icons.calendar_today),
                        onTap: _selectDate,
                      ),
                    ),
                    // location field
                    TextFormField(
                      controller: eventLocationController,
                      decoration: InputDecoration(
                        border: outlineInputBorder,
                        hintText: 'Enter event location...',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter event location';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _editEventHeader() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: primaryColor),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 4,
          children: [
            Icon(Icons.event_note, size: 90.0, color: primaryFgColor),
            Text(
              "Edit Event",
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

  // edit the form
  Future<void> _editEvent() async {
    if (_formKey.currentState!.validate()) {
      final success = await EventService.updateEvent({
        'title': eventTitleController.text.trim(),
        'description': eventDescriptionController.text.trim(),
        'location': eventLocationController.text.trim(),
        'date': selectedDate!.toIso8601String().split('T')[0],
      }, widget.eventId);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Event updated"),
            backgroundColor: Colors.green,
          ),
        );
        // refresh event
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to update event"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
    // validate date
    if (selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Pick a date"), backgroundColor: Colors.red),
      );
      return;
    }
  }

  // select date function
  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
}
