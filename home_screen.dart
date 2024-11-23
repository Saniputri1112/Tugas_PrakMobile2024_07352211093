import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:praktikum_mobile/screens/detail_screen.dart';
import 'edit_profile_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Map<String, dynamic>> news = [
    {
      'title': 'Praktikum Mobile',
      'description':
          'Sani Putri Pratiwi dari kelas mobile 5IF4 sedang mengikuti praktikum mobile',
      'imageUrl':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQt5WX189FafKeIM1NySLXF3GziPPte-ypHGQ&s',
      'author': 'Sani',
      'time': '10:00 AM',
    },
    {
      'title': 'Informatika Peduli',
      'description':
          'Dalam rangka menyambut bulan suci ramadhan, mahasiswa teknik informatika mengadakan kunjungan ke panti asuhan dan berbagi sembako',
      'imageUrl':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTz2m9zjNsiwKu1wU-MwCy1p20BvDwUhRv3Rg&s',
      'author': 'Sani Putri',
      'time': '11:00 AM',
    },
    {
      'title': 'Staff Of The Month',
      'description':
          'Setiap bulannya terdapat perhargaan staff on the month untuk mahasiswa teknik informatika yang sudah menjalankan tugas di masing masing bidang pengurus himpunana teknik',
      'imageUrl':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQBi1hOXLo1t_TU-qeXW7rKEmOMqXvtR7VMOA&s',
      'author': 'Sunny',
      'time': '11:00 AM',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      ListView.builder(
        itemCount: news.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailScreen(
                      title: news[index]['title'],
                      description: news[index]['description'],
                      imageUrl: news[index]['imageUrl'],
                    ),
                  ),
                );
              },
              child: Card(
                elevation: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        news[index]['imageUrl'],
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        news[index]['title'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        '${news[index]['author']} . ${news[index]['time']}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      const Center(child: Text('Explore Page')),
      const Center(child: Text('Bookmark Page')),
      EditProfileScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Text(
              'HMTI',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              ' News',
              style: TextStyle(
                color: Color(0xFF1877F2),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF1877F2),
              ),
              child: Text(
                'Pengaturan',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profil'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditProfileScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Pengaturan'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: const Color(0xFF1877F2),
        unselectedItemColor: Colors.black,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Bookmark',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
