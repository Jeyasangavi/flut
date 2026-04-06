/*
run in andriod studio

ADD IN pubspec.yaml:

dependencies:
  flutter:
    sdk: flutter
  sqflite: ^2.3.0
  path: ^1.9.0
  google_fonts: ^6.1.0 # Added for better typography

RUN:
flutter pub get
*/

iimport 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' show join;
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const LibraryApp());
}

class LibraryApp extends StatelessWidget {
  const LibraryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Library',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: const LibraryPage(),
    );
  }
}

// BOOK MODEL
class Book {
  int? id;
  String title;
  String author;
  String category;

  Book({this.id, required this.title, required this.author, required this.category});

  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'author': author, 'category': category};
  }
}

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  Database? db;
  List<Book> books = [];
  bool isLoading = true;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  String selectedCategory = 'Fiction';
  final List<String> categories = ['Fiction', 'Non-Fiction', 'Science', 'History', 'Biography'];

  @override
  void initState() {
    super.initState();
    initDB();
  }

  Future<void> initDB() async {
    db = await openDatabase(
      join(await getDatabasesPath(), 'library_v2.db'),
      onCreate: (database, version) {
        return database.execute(
          "CREATE TABLE books(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, author TEXT, category TEXT)",
        );
      },
      version: 1,
    );
    fetchBooks();
  }

  Future<void> fetchBooks() async {
    final data = await db!.query('books', orderBy: 'id DESC');
    setState(() {
      books = data.map((e) => Book(
        id: e['id'] as int,
        title: e['title'] as String,
        author: e['author'] as String,
        category: e['category'] as String,
      )).toList();
      isLoading = false;
    });
  }

  // --- CRUD OPERATIONS ---
  Future<void> saveBook({int? id}) async {
    if (titleController.text.isEmpty || authorController.text.isEmpty) return;

    final book = Book(
      id: id,
      title: titleController.text,
      author: authorController.text,
      category: selectedCategory,
    );

    if (id == null) {
      await db!.insert('books', book.toMap());
    } else {
      await db!.update('books', book.toMap(), where: 'id = ?', whereArgs: [id]);
    }

    titleController.clear();
    authorController.clear();
    fetchBooks();
    if (mounted) Navigator.pop(context);
  }

  Future<void> deleteBook(int id) async {
    await db!.delete('books', where: 'id = ?', whereArgs: [id]);
    fetchBooks();
  }

  // --- UI COMPONENTS ---
  void showBookSheet({Book? book}) {
    if (book != null) {
      titleController.text = book.title;
      authorController.text = book.author;
      selectedCategory = book.category;
    } else {
      titleController.clear();
      authorController.clear();
      selectedCategory = 'Fiction';
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
          left: 20, right: 20, top: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(book == null ? "Add New Book" : "Edit Book", 
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            TextField(controller: titleController, decoration: const InputDecoration(labelText: "Book Title", border: OutlineInputBorder())),
            const SizedBox(height: 10),
            TextField(controller: authorController, decoration: const InputDecoration(labelText: "Author Name", border: OutlineInputBorder())),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedCategory,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items: categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (val) => setState(() => selectedCategory = val!),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(15)),
                onPressed: () => saveBook(id: book?.id),
                child: Text(book == null ? "Add to Library" : "Update Details"),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text("Lumina Library", style: GoogleFonts.philosopher(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : books.isEmpty
              ? Center(child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.library_books_outlined, size: 80, color: Colors.grey[300]),
                    const Text("Your library is empty", style: TextStyle(color: Colors.grey)),
                  ],
                ))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: books.length,
                  itemBuilder: (context, index) {
                    final b = books[index];
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: Container(
                          width: 50, height: 50,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.menu_book_rounded),
                        ),
                        title: Text(b.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text("${b.author} • ${b.category}"),
                        trailing: PopupMenuButton(
                          itemBuilder: (ctx) => [
                            const PopupMenuItem(value: 'edit', child: Text("Edit")),
                            const PopupMenuItem(value: 'delete', child: Text("Delete", style: TextStyle(color: Colors.red))),
                          ],
                          onSelected: (val) {
                            if (val == 'edit') showBookSheet(book: b);
                            if (val == 'delete') deleteBook(b.id!);
                          },
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showBookSheet(),
        label: const Text("New Book"),
        icon: const Icon(Icons.add),
      ),
    );
  }
}