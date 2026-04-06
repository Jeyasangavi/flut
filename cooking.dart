import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(CookingApp());
}

class CookingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CookingPage(),
    );
  }
}

class CookingPage extends StatefulWidget {
  @override
  _CookingPageState createState() => _CookingPageState();
}

class _CookingPageState extends State<CookingPage> {
  Map<String, int> recipes = {
    "Rice": 600,   // 10 min
    "Pasta": 480,  // 8 min
    "Cake": 1200,  // 20 min
    "Egg": 300,    // 5 min
  };

  String selectedRecipe = "Rice";
  int totalTime = 600;
  int remainingTime = 600;

  Timer? timer;
  bool isRunning = false;

  @override
  void initState() {
    super.initState();
    loadRecipe(selectedRecipe);
  }

  void loadRecipe(String recipe) {
    setState(() {
      selectedRecipe = recipe;
      totalTime = recipes[recipe]!;
      remainingTime = totalTime;
      timer?.cancel();
      isRunning = false;
    });
  }

  void startTimer() {
    if (isRunning) return;

    timer = Timer.periodic(Duration(seconds: 1), (t) {
      if (remainingTime > 0) {
        setState(() {
          remainingTime--;
        });
      } else {
        t.cancel();
        isRunning = false;
        showFinishDialog();
      }
    });

    setState(() {
      isRunning = true;
    });
  }

  void pauseTimer() {
    timer?.cancel();
    setState(() {
      isRunning = false;
    });
  }

  void resetTimer() {
    timer?.cancel();
    setState(() {
      remainingTime = totalTime;
      isRunning = false;
    });
  }

  void showFinishDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Done! 🍳"),
        content: Text("Your $selectedRecipe is ready!"),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          )
        ],
      ),
    );
  }

  String formatTime(int seconds) {
    int m = seconds ~/ 60;
    int s = seconds % 60;
    return "${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    double progress = remainingTime / totalTime;

    return Scaffold(
      appBar: AppBar(
        title: Text("Cooking Timer"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [

            // RECIPE DROPDOWN
            DropdownButton<String>(
              value: selectedRecipe,
              isExpanded: true,
              items: recipes.keys.map((recipe) {
                return DropdownMenuItem(
                  value: recipe,
                  child: Text(recipe),
                );
              }).toList(),
              onChanged: (value) {
                loadRecipe(value!);
              },
            ),

            SizedBox(height: 30),

            // TIMER DISPLAY
            Text(
              formatTime(remainingTime),
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 20),

            // PROGRESS BAR
            LinearProgressIndicator(
              value: progress,
              minHeight: 10,
            ),

            SizedBox(height: 30),

            // CONTROL BUTTONS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: startTimer,
                  child: Text("▶ Start"),
                ),
                ElevatedButton(
                  onPressed: pauseTimer,
                  child: Text("⏸ Pause"),
                ),
                ElevatedButton(
                  onPressed: resetTimer,
                  child: Text("🔄 Reset"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}