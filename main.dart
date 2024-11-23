import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const ECommerceApp());
}

class ECommerceApp extends StatelessWidget {
  const ECommerceApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sani E-Commerce',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
      ),
      home: const SplashScreen(),
    );
  }
}

// Splash Screen
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const BookListPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF5B86E5), Color(0xFF36D1DC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.shopping_bag, size: 80, color: Colors.white),
              SizedBox(height: 16),
              Text(
                'Welcome to E-Commerce App',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Explore the world of books',
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Model Buku
class Book {
  final String id;
  final String title;
  final String author;
  final String description;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'].toString(),
      title: json['title'],
      author: json['author'],
      description: json['description'],
    );
  }
}

// Fungsi HTTP Request
Future<List<Book>> fetchBooks() async {
  final response =
      await http.get(Uri.parse('https://events.hmti.unkhair.ac.id/api/books'));
  if (response.statusCode == 200) {
    final List data = json.decode(response.body);
    return data.map((json) => Book.fromJson(json)).toList();
  } else {
    throw Exception('Gagal memuat daftar buku');
  }
}

Future<Book> fetchBookById(String id) async {
  final response = await http
      .get(Uri.parse('https://events.hmti.unkhair.ac.id/api/books/$id'));
  if (response.statusCode == 200) {
    return Book.fromJson(json.decode(response.body));
  } else if (response.statusCode == 404) {
    throw Exception('Buku tidak ditemukan');
  } else {
    throw Exception('Gagal memuat detail buku');
  }
}

Future<void> addBook(String title, String author, String description) async {
  final response = await http.post(
    Uri.parse('https://events.hmti.unkhair.ac.id/api/books'),
    headers: {'Content-Type': 'application/json'},
    body: json
        .encode({'title': title, 'author': author, 'description': description}),
  );
  if (response.statusCode != 201) {
    throw Exception('Gagal menambahkan buku');
  }
}

Future<void> updateBook(
    String id, String title, String author, String description) async {
  final response = await http.put(
    Uri.parse('https://events.hmti.unkhair.ac.id/api/books/$id'),
    headers: {'Content-Type': 'application/json'},
    body: json
        .encode({'title': title, 'author': author, 'description': description}),
  );
  if (response.statusCode != 200) {
    throw Exception('Gagal memperbarui buku');
  }
}

Future<void> deleteBook(String id) async {
  final response = await http
      .delete(Uri.parse('https://events.hmti.unkhair.ac.id/api/books/$id'));
  if (response.statusCode != 200) {
    throw Exception('Gagal menghapus buku');
  }
}

// Daftar Buku
class BookListPage extends StatefulWidget {
  const BookListPage({super.key});
  @override
  _BookListPageState createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> {
  late Future<List<Book>> books;

  @override
  void initState() {
    super.initState();
    books = fetchBooks();
  }

  void refreshBooks() {
    setState(() {
      books = fetchBooks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Buku'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddBookPage(onBookAdded: refreshBooks),
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<Book>>(
        future: books,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada buku tersedia'));
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final book = snapshot.data![index];
              return ListTile(
                title: Text(book.title),
                subtitle: Text(book.author),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookDetailPage(
                        bookId: book.id, onBookUpdated: refreshBooks),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// Tambah Buku
class AddBookPage extends StatefulWidget {
  final VoidCallback onBookAdded;

  const AddBookPage({required this.onBookAdded, super.key});

  @override
  _AddBookPageState createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String author = '';
  String description = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Buku')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Judul Buku'),
                onSaved: (value) => title = value!,
                validator: (value) =>
                    value!.isEmpty ? 'Judul tidak boleh kosong' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Penulis'),
                onSaved: (value) => author = value!,
                validator: (value) =>
                    value!.isEmpty ? 'Penulis tidak boleh kosong' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Deskripsi'),
                onSaved: (value) => description = value!,
                validator: (value) =>
                    value!.isEmpty ? 'Deskripsi tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    await addBook(title, author, description);
                    widget.onBookAdded();
                    Navigator.pop(context);
                  }
                },
                child: const Text('Tambah'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Halaman Edit Buku
class EditBookPage extends StatefulWidget {
  final Book book;
  final VoidCallback onBookUpdated;

  const EditBookPage(
      {required this.book, required this.onBookUpdated, super.key});

  @override
  _EditBookPageState createState() => _EditBookPageState();
}

class _EditBookPageState extends State<EditBookPage> {
  final _formKey = GlobalKey<FormState>();
  late String title;
  late String author;
  late String description;

  @override
  void initState() {
    super.initState();
    title = widget.book.title;
    author = widget.book.author;
    description = widget.book.description;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Buku')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: title,
                decoration: const InputDecoration(labelText: 'Judul Buku'),
                onSaved: (value) => title = value!,
                validator: (value) =>
                    value!.isEmpty ? 'Judul tidak boleh kosong' : null,
              ),
              TextFormField(
                initialValue: author,
                decoration: const InputDecoration(labelText: 'Penulis'),
                onSaved: (value) => author = value!,
                validator: (value) =>
                    value!.isEmpty ? 'Penulis tidak boleh kosong' : null,
              ),
              TextFormField(
                initialValue: description,
                decoration: const InputDecoration(labelText: 'Deskripsi'),
                onSaved: (value) => description = value!,
                validator: (value) =>
                    value!.isEmpty ? 'Deskripsi tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    await updateBook(
                        widget.book.id, title, author, description);
                    widget.onBookUpdated();
                    Navigator.pop(context);
                  }
                },
                child: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Detail Buku
class BookDetailPage extends StatelessWidget {
  final String bookId;
  final VoidCallback onBookUpdated;

  const BookDetailPage({
    required this.bookId,
    required this.onBookUpdated,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Buku')),
      body: FutureBuilder<Book>(
        future: fetchBookById(bookId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final book = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(book.title,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(book.author, style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 16),
                Text(book.description),
                const SizedBox(height: 16),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        await deleteBook(book.id);
                        onBookUpdated();
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text('Hapus'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditBookPage(
                            book: book,
                            onBookUpdated: onBookUpdated,
                          ),
                        ),
                      ),
                      child: const Text('Edit'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
