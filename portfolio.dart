import 'package:flutter/material.dart';

void main() {
  runApp(PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PortfolioPage(),
    );
  }
}

class PortfolioPage extends StatelessWidget {
  final GlobalKey aboutKey = GlobalKey();
  final GlobalKey projectKey = GlobalKey();
  final GlobalKey blogKey = GlobalKey();
  final GlobalKey contactKey = GlobalKey();

  void scrollTo(GlobalKey key) {
    Scrollable.ensureVisible(
      key.currentContext!,
      duration: Duration(milliseconds: 700),
      curve: Curves.easeInOut,
    );
  }

  Widget navItem(String title, GlobalKey key) {
    return TextButton(
      onPressed: () => scrollTo(key),
      child: Text(title,
          style: TextStyle(color: Colors.white, fontSize: 16)),
    );
  }

  Widget section(String title, String content, GlobalKey key) {
    return Container(
      key: key,
      padding: EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      width: double.infinity,
      child: Column(
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 32, fontWeight: FontWeight.bold)),
          SizedBox(height: 20),
          Text(
            content,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget projectCard(String title, String desc) {
    return Card(
      elevation: 5,
      child: Container(
        width: 250,
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Text(title,
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text(desc),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      // NAVBAR
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("My Portfolio"),
        actions: [
          navItem("About", aboutKey),
          navItem("Projects", projectKey),
          navItem("Blog", blogKey),
          navItem("Contact", contactKey),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [

            // HERO SECTION
            Container(
              height: 300,
              width: double.infinity,
              color: Colors.blue,
              child: Center(
                child: Text(
                  "Hi, I'm a Flutter Developer 👋",
                  style: TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),

            // ABOUT
            section(
              "About Me",
              "I am a passionate developer skilled in Flutter and web technologies. I love building clean and user-friendly applications.",
              aboutKey,
            ),

            // PROJECTS
            Container(
              key: projectKey,
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Text("Projects",
                      style: TextStyle(
                          fontSize: 32, fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),
                  Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    children: [
                      projectCard("Todo App", "Task management app"),
                      projectCard("BMI App", "Health calculator"),
                      projectCard("Expense Tracker", "Track spending"),
                    ],
                  ),
                ],
              ),
            ),

            // BLOG
            section(
              "Blog",
              "I write articles about Flutter, UI design, and mobile app development.",
              blogKey,
            ),

            // CONTACT
            section(
              "Contact",
              "Email: example@mail.com\nPhone: 1234567890",
              contactKey,
            ),
          ],
        ),
      ),
    );
  }
}