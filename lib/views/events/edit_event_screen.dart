import 'package:flutter/material.dart';
import 'package:refresher/constants/color_scheme.dart';

class EditEventScreen extends StatefulWidget {
  const EditEventScreen({super.key});

  @override
  State<EditEventScreen> createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  // form key
  final _formKey = GlobalKey<FormState>();
  // textfield controllers
  final eventTitleController = TextEditingController();
  final eventDescriptionController = TextEditingController();
  final eventLocationController = TextEditingController();
  final eventDateController = TextEditingController();

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
    eventDateController.dispose();
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
          IconButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // If the form is valid, display a snackbar. In the real world,
                // you'd often call a server or save the information in a database.
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Processing Data')),
                );
              }
            },
            icon: Icon(Icons.edit),
          ),
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
                    TextFormField(
                      controller: eventDateController,
                      readOnly: true,
                      decoration: InputDecoration(
                        border: outlineInputBorder,
                        hintText: 'No date selected',
                        suffixIcon: IconButton(
                          onPressed: _selectDate,
                          icon: Icon(Icons.date_range),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a date';
                        }
                        return null;
                      },
                    ),
                    // location field
                    TextFormField(
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

  // select date function
  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );

    setState(() {
      String selectedDate =
          "${pickedDate?.month}-${pickedDate?.day}-${pickedDate?.year}";
      eventDateController.text = selectedDate;
    });
  }
}
