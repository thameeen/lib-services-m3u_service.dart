import 'package:flutter/material.dart';

void main() {
  runApp(const HeedarTVApp());
}

class HeedarTVApp extends StatelessWidget {
  const HeedarTVApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HeedarTV',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF111111),
      ),
      home: const MainHomeScreen(),
    );
  }
}

class MainHomeScreen extends StatelessWidget {
  const MainHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'HEEDAR TV',
          style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.refresh), onPressed: () {}),
          IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // أزرار الواجهة الرئيسية (Live TV, Movies, Series)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildMenuCard(
                  context,
                  title: "Live TV's",
                  subtitle: "+5000 Channels",
                  icon: Icons.tv,
                  onTap: () {
                    // شاشة البث المباشر
                  },
                ),
                // زر الأفلام المعدل لينتقل للمحتوى الداخلي مباشرة
                _buildMenuCard(
                  context,
                  title: "Movies",
                  subtitle: "+12000 Movies",
                  icon: Icons.movie,
                  isHighlighted: true,
                  onTap: () {
                    // الانتقال المباشر إلى شاشة الأفلام الداخلية من جوّا
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const InternalMoviesScreen()),
                    );
                  },
                ),
                _buildMenuCard(
                  context,
                  title: "Series",
                  subtitle: "+7000 Series",
                  icon: Icons.video_library,
                  onTap: () {
                    // شاشة المسلسلات
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    bool isHighlighted = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 180,
        height: 120,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isHighlighted ? Colors.greenAccent : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.greenAccent, size: 28),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

// شاشة الأفلام الداخلية التي ستفتح مباشرة عند النقر على زر Movies
class InternalMoviesScreen extends StatelessWidget {
  const InternalMoviesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies Library'),
        backgroundColor: const Color(0xFF1E1E1E),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(15),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4, // عدد الأفلام في العرض لكل صف
          childAspectRatio: 0.7,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: 20, // عدد تجريبي للأفلام
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.grey[850],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                'Movie ${index + 1}',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          );
        },
      ),
    );
  }
}
