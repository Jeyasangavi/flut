import 'package:flutter/material.dart';

void main() {
  runApp(EventApp());
}

class EventApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: EventPage(),
    );
  }
}

// Model
class Event {
  String title;
  String date;
  String time;
  String location;
  String description;

  Event({
    required this.title,
    required this.date,
    required this.time,
    required this.location,
    required this.description,
  });
}

class EventPage extends StatefulWidget {
  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  List<Event> events = [];

  TextEditingController titleController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  // DATE PICKER
  Future<void> pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      dateController.text =
          "${picked.day}/${picked.month}/${picked.year}";
    }
  }

  // TIME PICKER
  Future<void> pickTime() async {
    TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());

    if (picked != null) {
      timeController.text = picked.format(context);
    }
  }

  void addEvent() {
    if (titleController.text.isEmpty ||
        dateController.text.isEmpty ||
        timeController.text.isEmpty ||
        locationController.text.isEmpty ||
        descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Fill all fields")),
      );
      return;
    }

    setState(() {
      events.add(Event(
        title: titleController.text,
        date: dateController.text,
        time: timeController.text,
        location: locationController.text,
        description: descriptionController.text,
      ));

      titleController.clear();
      dateController.clear();
      timeController.clear();
      locationController.clear();
      descriptionController.clear();
    });
  }

  void editEvent(int index) {
    titleController.text = events[index].title;
    dateController.text = events[index].date;
    timeController.text = events[index].time;
    locationController.text = events[index].location;
    descriptionController.text = events[index].description;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Event"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(controller: titleController, decoration: InputDecoration(labelText: "Title")),
                TextField(controller: dateController, readOnly: true, decoration: InputDecoration(labelText: "Date"), onTap: pickDate),
                TextField(controller: timeController, readOnly: true, decoration: InputDecoration(labelText: "Time"), onTap: pickTime),
                TextField(controller: locationController, decoration: InputDecoration(labelText: "Location")),
                TextField(controller: descriptionController, decoration: InputDecoration(labelText: "Description")),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  events[index] = Event(
                    title: titleController.text,
                    date: dateController.text,
                    time: timeController.text,
                    location: locationController.text,
                    description: descriptionController.text,
                  );
                });
                Navigator.pop(context);
              },
              child: Text("Update"),
            ),
          ],
        );
      },
    );
  }

  void viewEvent(Event e) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(e.title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Date: ${e.date}"),
              Text("Time: ${e.time}"),
              Text("Location: ${e.location}"),
              Text("Description: ${e.description}"),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }

  void deleteEvent(int index) {
    setState(() {
      events.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Event Manager"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                      labelText: "Title", border: OutlineInputBorder()),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: dateController,
                  readOnly: true,
                  decoration: InputDecoration(
                      labelText: "Date", border: OutlineInputBorder()),
                  onTap: pickDate,
                ),
                SizedBox(height: 10),
                TextField(
                  controller: timeController,
                  readOnly: true,
                  decoration: InputDecoration(
                      labelText: "Time", border: OutlineInputBorder()),
                  onTap: pickTime,
                ),
                SizedBox(height: 10),
                TextField(
                  controller: locationController,
                  decoration: InputDecoration(
                      labelText: "Location",
                      border: OutlineInputBorder()),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                      labelText: "Description",
                      border: OutlineInputBorder()),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: addEvent,
                  child: Text("Add Event"),
                ),
              ],
            ),
          ),

          Expanded(
            child: events.isEmpty
                ? Center(child: Text("No events added"))
                : ListView.builder(
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: ListTile(
                          title: Text(events[index].title),
                          subtitle: Text(
                              "${events[index].date} | ${events[index].time}"),
                          onTap: () => viewEvent(events[index]),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () => editEvent(index),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () => deleteEvent(index),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}