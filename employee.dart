import 'package:flutter/material.dart';

void main() {
  runApp(EmployeeApp());
}

class EmployeeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: EmployeeHomePage(),
    );
  }
}

// Model class
class Employee {
  String name;
  String position;
  double salary;

  Employee({
    required this.name,
    required this.position,
    required this.salary,
  });
}

class EmployeeHomePage extends StatefulWidget {
  @override
  _EmployeeHomePageState createState() => _EmployeeHomePageState();
}

class _EmployeeHomePageState extends State<EmployeeHomePage> {
  List<Employee> employees = [];

  TextEditingController nameController = TextEditingController();
  TextEditingController positionController = TextEditingController();
  TextEditingController salaryController = TextEditingController();

  void addEmployee() {
    if (nameController.text.isEmpty ||
        positionController.text.isEmpty ||
        salaryController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Enter all details")),
      );
      return;
    }

    double salary = double.tryParse(salaryController.text) ?? 0;

    setState(() {
      employees.add(Employee(
        name: nameController.text,
        position: positionController.text,
        salary: salary,
      ));

      nameController.clear();
      positionController.clear();
      salaryController.clear();
    });
  }

  void editEmployee(int index) {
    nameController.text = employees[index].name;
    positionController.text = employees[index].position;
    salaryController.text = employees[index].salary.toString();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Employee"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: "Name"),
                ),
                TextField(
                  controller: positionController,
                  decoration: InputDecoration(labelText: "Position"),
                ),
                TextField(
                  controller: salaryController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "Salary"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  employees[index].name = nameController.text;
                  employees[index].position = positionController.text;
                  employees[index].salary =
                      double.tryParse(salaryController.text) ?? 0;
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

  void viewEmployee(Employee emp) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Employee Details"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Name: ${emp.name}"),
              Text("Position: ${emp.position}"),
              Text("Salary: ₹ ${emp.salary.toStringAsFixed(2)}"),
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

  void deleteEmployee(int index) {
    setState(() {
      employees.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Employee Manager"),
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
                    labelText: "Name",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: positionController,
                  decoration: InputDecoration(
                    labelText: "Position",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: salaryController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Salary",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: addEmployee,
                  child: Text("Add Employee"),
                ),
              ],
            ),
          ),
          Expanded(
            child: employees.isEmpty
                ? Center(child: Text("No employees added"))
                : ListView.builder(
                    itemCount: employees.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: ListTile(
                          title: Text(employees[index].name),
                          subtitle:
                              Text(employees[index].position),
                          onTap: () => viewEmployee(employees[index]),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () => editEmployee(index),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () => deleteEmployee(index),
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