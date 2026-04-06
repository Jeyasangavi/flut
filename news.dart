import 'package:flutter/material.dart';

void main() {
  runApp(NewsApp());
}

class NewsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NewsHomePage(),
    );
  }
}

// Model for News
class News {
  String title;
  String description;

  News({required this.title, required this.description});
}

class NewsHomePage extends StatelessWidget {
  // Sample static data (offline safe)
  final List<News> newsList = [
    News(
        title: "AI is transforming the world",
        description:
            "Artificial Intelligence is rapidly changing industries, from healthcare to finance, making processes faster and smarter."),
    News(
        title: "Flutter gains popularity",
        description:
            "Flutter is becoming one of the most popular frameworks for building cross-platform applications efficiently."),
    News(
        title: "SpaceX launches new rocket",
        description:
            "SpaceX successfully launched a new rocket, marking another milestone in space exploration."),
    News(
        title: "Climate change concerns rise",
        description:
            "Global leaders are focusing more on climate change as temperatures continue to rise worldwide."),
    News(
        title: "Tech companies expand globally",
        description:
            "Major tech companies are expanding their operations into new international markets."),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("News Headlines"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: newsList.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              title: Text(newsList[index].title),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        NewsDetailPage(news: newsList[index]),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// Detail Page
class NewsDetailPage extends StatelessWidget {
  final News news;

  NewsDetailPage({required this.news});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("News Details"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              news.title,
              style: TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15),
            Text(
              news.description,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}