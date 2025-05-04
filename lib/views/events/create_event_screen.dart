import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:refresher/constants/color_scheme.dart';
import 'package:refresher/services/event_service.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  // form key
  final _formKey = GlobalKey<FormState>();
  // textfield controllers
  final TextEditingController eventTitleController = TextEditingController();
  final TextEditingController eventDescriptionController =
      TextEditingController();
  final TextEditingController eventLocationController = TextEditingController();

  // selectdate var
  DateTime? selectedDate;

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: primaryFgColor,
        actions: [
          // create button
          IconButton(onPressed: _createEvent, icon: Icon(Icons.add)),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // create new event header
              _createEventHeader(),
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

  Widget _createEventHeader() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: primaryColor),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 4,
          children: [
            Icon(Icons.event_available, size: 90.0, color: primaryFgColor),
            Text(
              "Create New Event",
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

  // pass the form
  Future<void> _createEvent() async {
    if (_formKey.currentState!.validate()) {
      final success = await EventService.addEvent({
        'title': eventTitleController.text.trim(),
        'description': eventDescriptionController.text.trim(),
        'location': eventLocationController.text.trim(),
        'date': selectedDate!.toIso8601String().split('T')[0],
      });
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Event added"), backgroundColor: Colors.green),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to add event"),
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
