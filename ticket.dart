import 'package:flutter/material.dart';

void main() {
  runApp(TicketApp());
}

class TicketApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TicketHomePage(),
    );
  }
}

// Model class
class Ticket {
  String name;
  String from;
  String to;
  String date;

  Ticket({
    required this.name,
    required this.from,
    required this.to,
    required this.date,
  });
}

class TicketHomePage extends StatefulWidget {
  @override
  _TicketHomePageState createState() => _TicketHomePageState();
}

class _TicketHomePageState extends State<TicketHomePage> {
  List<Ticket> tickets = [];

  TextEditingController nameController = TextEditingController();
  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  Future<void> selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        dateController.text =
            "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  void addTicket() {
    if (nameController.text.isEmpty ||
        fromController.text.isEmpty ||
        toController.text.isEmpty ||
        dateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Enter all details")),
      );
      return;
    }

    setState(() {
      tickets.add(Ticket(
        name: nameController.text,
        from: fromController.text,
        to: toController.text,
        date: dateController.text,
      ));

      nameController.clear();
      fromController.clear();
      toController.clear();
      dateController.clear();
    });
  }

  void editTicket(int index) {
    nameController.text = tickets[index].name;
    fromController.text = tickets[index].from;
    toController.text = tickets[index].to;
    dateController.text = tickets[index].date;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Ticket"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(controller: nameController, decoration: InputDecoration(labelText: "Name")),
                TextField(controller: fromController, decoration: InputDecoration(labelText: "From")),
                TextField(controller: toController, decoration: InputDecoration(labelText: "To")),
                TextField(
                  controller: dateController,
                  readOnly: true,
                  decoration: InputDecoration(labelText: "Date"),
                  onTap: selectDate,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  tickets[index].name = nameController.text;
                  tickets[index].from = fromController.text;
                  tickets[index].to = toController.text;
                  tickets[index].date = dateController.text;
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

  void viewTicket(Ticket ticket) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Ticket Details"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Name: ${ticket.name}"),
              Text("From: ${ticket.from}"),
              Text("To: ${ticket.to}"),
              Text("Date: ${ticket.date}"),
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

  void deleteTicket(int index) {
    setState(() {
      tickets.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ticket Booking"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Passenger Name",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: fromController,
                  decoration: InputDecoration(
                    labelText: "From",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: toController,
                  decoration: InputDecoration(
                    labelText: "To",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: dateController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "Journey Date",
                    border: OutlineInputBorder(),
                  ),
                  onTap: selectDate,
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: addTicket,
                  child: Text("Book Ticket"),
                ),
              ],
            ),
          ),
          Expanded(
            child: tickets.isEmpty
                ? Center(child: Text("No tickets booked"))
                : ListView.builder(
                    itemCount: tickets.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: ListTile(
                          title: Text(tickets[index].name),
                          subtitle: Text("${tickets[index].from} → ${tickets[index].to}"),
                          onTap: () => viewTicket(tickets[index]),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () => editTicket(index),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () => deleteTicket(index),
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