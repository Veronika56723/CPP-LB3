import 'package:flutter/material.dart';
import 'database.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Database',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const BookListScreen(),
    );
  }
}

class BookListScreen extends StatefulWidget {
  const BookListScreen({super.key});

  @override
  State<BookListScreen> createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  final dbHelper = DatabaseHelper.instance;
  List<Map<String, dynamic>> books = [];
  final TextEditingController titleController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _queryAll();
  }

  void _insert() async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnTitle: titleController.text,
      DatabaseHelper.columnAuthor: authorController.text,
    };
    final id = await dbHelper.insert(row);
    debugPrint('inserted row id: $id');
    _queryAll();
    titleController.clear();
    authorController.clear();
  }

  void _queryAll() async {
    final allRows = await dbHelper.queryAllRows();
    setState(() {
      books = allRows;
    });
    debugPrint('query all rows:');
    allRows.forEach((row) => debugPrint(row.toString()));
  }

  void _query(String title) async {
    final rows = await dbHelper.queryRows(title);
    setState(() {
      books = rows;
    });
    debugPrint('query "$title":');
    rows.forEach((row) => debugPrint(row.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Database'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Book Title'),
            ),
            TextField(
              controller: authorController,
              decoration: const InputDecoration(labelText: 'Author'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _insert,
              child: const Text('Add Book'),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: searchController,
              decoration: const InputDecoration(labelText: 'Search by Title'),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  _query(value);
                } else {
                  _queryAll();
                }
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: books.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Title: ${books[index]['title']}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          Text('Author: ${books[index]['author']}'),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
