import 'package:flutter/material.dart';

void main() {
  runApp(StudentApp());
}

class StudentApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StudentHomePage(),
    );
  }
}

// Model class
class Student {
  String name;
  String id;
  String grade;

  Student({required this.name, required this.id, required this.grade});
}

class StudentHomePage extends StatefulWidget {
  @override
  _StudentHomePageState createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  List<Student> students = [];

  TextEditingController nameController = TextEditingController();
  TextEditingController idController = TextEditingController();
  TextEditingController gradeController = TextEditingController();

  void addStudent() {
    if (nameController.text.isEmpty ||
        idController.text.isEmpty ||
        gradeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Enter all details")),
      );
      return;
    }

    setState(() {
      students.add(Student(
        name: nameController.text,
        id: idController.text,
        grade: gradeController.text,
      ));

      nameController.clear();
      idController.clear();
      gradeController.clear();
    });
  }

  void editStudent(int index) {
    nameController.text = students[index].name;
    idController.text = students[index].id;
    gradeController.text = students[index].grade;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Update Student"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Name"),
              ),
              TextField(
                controller: idController,
                decoration: InputDecoration(labelText: "ID"),
              ),
              TextField(
                controller: gradeController,
                decoration: InputDecoration(labelText: "Grade"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  students[index].name = nameController.text;
                  students[index].id = idController.text;
                  students[index].grade = gradeController.text;
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

  void viewStudent(Student student) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Student Details"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Name: ${student.name}"),
              Text("ID: ${student.id}"),
              Text("Grade: ${student.grade}"),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Student Manager"),
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
                    labelText: "Student Name",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: idController,
                  decoration: InputDecoration(
                    labelText: "Student ID",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: gradeController,
                  decoration: InputDecoration(
                    labelText: "Grade",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: addStudent,
                  child: Text("Add Student"),
                ),
              ],
            ),
          ),
          Expanded(
            child: students.isEmpty
                ? Center(child: Text("No students added"))
                : ListView.builder(
                    itemCount: students.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: ListTile(
                          title: Text(students[index].name),
                          subtitle: Text("ID: ${students[index].id}"),
                          onTap: () => viewStudent(students[index]),
                          trailing: IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => editStudent(index),
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