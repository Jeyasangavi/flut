import 'package:flutter/material.dart';

void main() {
  runApp(ExpenseApp());
}

class ExpenseApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ExpenseHomePage(),
    );
  }
}

// Model class
class Expense {
  String title;
  double amount;

  Expense({required this.title, required this.amount});
}

class ExpenseHomePage extends StatefulWidget {
  @override
  _ExpenseHomePageState createState() => _ExpenseHomePageState();
}

class _ExpenseHomePageState extends State<ExpenseHomePage> {
  List<Expense> expenses = [];

  TextEditingController titleController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  void addExpense() {
    String title = titleController.text;
    String amountText = amountController.text;

    if (title.isEmpty || amountText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Enter both title and amount")),
      );
      return;
    }

    double amount = double.tryParse(amountText) ?? 0;

    setState(() {
      expenses.add(Expense(title: title, amount: amount));
      titleController.clear();
      amountController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Expense Manager"),
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
                    labelText: "Expense Title",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Amount",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: addExpense,
                  child: Text("Add Expense"),
                ),
              ],
            ),
          ),
          Expanded(
            child: expenses.isEmpty
                ? Center(child: Text("No expenses added"))
                : ListView.builder(
                    itemCount: expenses.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: ListTile(
                          title: Text(expenses[index].title),
                          subtitle: Text(
                              "₹ ${expenses[index].amount.toStringAsFixed(2)}"),
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