/*
run in android studio 

ADD THIS IN pubspec.yaml:

dependencies:
  flutter:
    sdk: flutter

  # ADD THESE TWO LINES HERE:
  sqflite: ^2.3.0
  path: ^1.9.1

  # Leave these as they are
  cupertino_icons: ^1.0.6

THEN RUN:
flutter pub get
*/
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
// This 'show join' is the specific fix for the error you encountered
import 'package:path/path.dart' show join;

void main() {
  runApp(const CustomerApp());
}

class CustomerApp extends StatelessWidget {
  const CustomerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Customer Manager',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const CustomerPage(),
    );
  }
}

// DATA MODEL
class Customer {
  int? id;
  String name;
  int age;
  String phone;

  Customer({this.id, required this.name, required this.age, required this.phone});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'phone': phone,
    };
  }
}

class CustomerPage extends StatefulWidget {
  const CustomerPage({super.key});

  @override
  State<CustomerPage> createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  Database? database;
  List<Customer> customers = [];

  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initDB();
  }

  // DATABASE INITIALIZATION
  Future<void> initDB() async {
    database = await openDatabase(
      join(await getDatabasesPath(), 'customers_db.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE customers(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, age INTEGER, phone TEXT)",
        );
      },
      version: 1,
    );
    fetchCustomers();
  }

  // READ
  Future<void> fetchCustomers() async {
    final List<Map<String, dynamic>> maps = await database!.query('customers');
    setState(() {
      customers = maps.map((e) => Customer(
        id: e['id'],
        name: e['name'],
        age: e['age'],
        phone: e['phone'],
      )).toList();
    });
  }

  // CREATE
  Future<void> addCustomer() async {
    if (nameController.text.isEmpty || ageController.text.isEmpty) return;

    await database!.insert(
      'customers',
      Customer(
        name: nameController.text,
        age: int.tryParse(ageController.text) ?? 0,
        phone: phoneController.text,
      ).toMap(),
    );

    _clearTextFields();
    fetchCustomers();
  }

  // UPDATE
  Future<void> updateCustomer(int id) async {
    await database!.update(
      'customers',
      Customer(
        id: id,
        name: nameController.text,
        age: int.tryParse(ageController.text) ?? 0,
        phone: phoneController.text,
      ).toMap(),
      where: 'id = ?',
      whereArgs: [id],
    );
    fetchCustomers();
  }

  // DELETE
  Future<void> deleteCustomer(int id) async {
    await database!.delete('customers', where: 'id = ?', whereArgs: [id]);
    fetchCustomers();
  }

  void _clearTextFields() {
    nameController.clear();
    ageController.clear();
    phoneController.clear();
  }

  // EDIT DIALOG UI
  void showEditDialog(Customer c) {
    nameController.text = c.name;
    ageController.text = c.age.toString();
    phoneController.text = c.phone;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Edit Customer"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: nameController, decoration: const InputDecoration(labelText: "Name")),
                TextField(controller: ageController, decoration: const InputDecoration(labelText: "Age"), keyboardType: TextInputType.number),
                TextField(controller: phoneController, decoration: const InputDecoration(labelText: "Phone"), keyboardType: TextInputType.phone),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _clearTextFields();
                Navigator.pop(dialogContext);
              },
              child: const Text("Cancel")
            ),
            ElevatedButton(
              onPressed: () {
                updateCustomer(c.id!);
                Navigator.pop(dialogContext);
                _clearTextFields();
              },
              child: const Text("Update"),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Customer Manager"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // INPUT SECTION
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    TextField(controller: nameController, decoration: const InputDecoration(labelText: "Full Name", icon: Icon(Icons.person))),
                    Row(
                      children: [
                        Expanded(child: TextField(controller: ageController, decoration: const InputDecoration(labelText: "Age"), keyboardType: TextInputType.number)),
                        const SizedBox(width: 15),
                        Expanded(child: TextField(controller: phoneController, decoration: const InputDecoration(labelText: "Phone"), keyboardType: TextInputType.phone)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: addCustomer,
                      icon: const Icon(Icons.person_add),
                      label: const Text("Save Customer"),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Divider(),
          // LIST SECTION
          Expanded(
            child: customers.isEmpty
              ? const Center(child: Text("No customers in database."))
              : ListView.builder(
                  itemCount: customers.length,
                  itemBuilder: (context, index) {
                    final c = customers[index];
                    return ListTile(
                      leading: CircleAvatar(child: Text(c.name[0].toUpperCase())),
                      title: Text(c.name),
                      subtitle: Text("Age: ${c.age} | Tel: ${c.phone}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => showEditDialog(c)),
                          IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => deleteCustomer(c.id!)),
                        ],
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