import 'package:flutter/material.dart';

void main() {
  runApp(BudgetApp());
}

class BudgetApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BudgetPage(),
    );
  }
}

class BudgetPage extends StatefulWidget {
  @override
  _BudgetPageState createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  TextEditingController incomeController = TextEditingController();
  TextEditingController expenseController = TextEditingController();
  TextEditingController goalController = TextEditingController();

  double savings = 0;
  double progress = 0;

  void calculate() {
    double income = double.tryParse(incomeController.text) ?? 0;
    double expense = double.tryParse(expenseController.text) ?? 0;
    double goal = double.tryParse(goalController.text) ?? 0;

    if (income <= 0 || goal <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Enter valid income and goal")),
      );
      return;
    }

    double available = income - expense;

    setState(() {
      savings = available;

      if (goal > 0) {
        progress = (available / goal).clamp(0, 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Budget Manager"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: incomeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Income",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 15),

            TextField(
              controller: expenseController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Expenses",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 15),

            TextField(
              controller: goalController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Savings Goal",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),

            ElevatedButton(
              onPressed: calculate,
              child: Text("Calculate"),
            ),

            SizedBox(height: 20),

            Text(
              "Available Savings: ₹ ${savings.toStringAsFixed(2)}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 20),

            LinearProgressIndicator(value: progress),

            SizedBox(height: 10),

            Text(
              "Progress: ${(progress * 100).toStringAsFixed(1)}%",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}