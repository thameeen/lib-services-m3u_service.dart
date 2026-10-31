import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const HeedarTVApp());
}

class HeedarTVApp extends StatelessWidget {
  const HeedarTVApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Heedar TV',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF070A09),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00FF66),
          surface: Color(0xFF121A17),
        ),
      ),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // الشريط العلوي
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      'HEEDAR TV',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00FF66),
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF121A17),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFF00FF66).withOpacity(0.5)),
                      ),
                      child: const Text(
                        'Free Trial - 5 Days Left',
                        style: TextStyle(color: Color(0xFF00FF66), fontSize: 12),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(icon: const Icon(Icons.search, color: Colors.white), onPressed: () {}),
                    IconButton(icon: const Icon(Icons.replay, color: Colors.white), onPressed: () {}),
                    IconButton(icon: const Icon(Icons.settings, color: Colors.white), onPressed: () {}),
                  ],
                )
              ],
            ),
            const SizedBox(height: 30),

            // الأقسام الرئيسية (Live TV, Movies, Series)
            Row(
              children: [
                Expanded(flex: 2, child: Row(
                  children: [
                    _buildCategoryCard('Live TV\'s', '+5000 Channels', Icons.tv, false),
                    const SizedBox(width: 15),
                    _buildCategoryCard('Movies', '+12000 Movies', Icons.movie, true), // محدد بالإطار الأخضر
                    const SizedBox(width: 15),
                    _buildCategoryCard('Series', '+7000 Series', Icons.video_library, false),
                  ],
                )),
                const SizedBox(width: 20),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      _buildSideCard('Favorites', '422 Items', Icons.favorite),
                      const SizedBox(height: 10),
                      _buildSideCard('Playlists', '1 Playlist', Icons.playlist_play),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 30),

            // قسم متابعة المشاهدة
            const Text(
              'Continue Watching',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                _buildContinueItem('Dark City Chronicles', 'Season 2 - Episode 8'),
                const SizedBox(width: 15),
                _buildContinueItem('La Casa De Papel', 'Season 4 - Episode 3'),
                const SizedBox(width: 15),
                _buildContinueItem('Lilo & Stitch', '2023'),
              ],
            ),
            const Spacer(),

            // الشريط السفلي ومعلومات الجهاز
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Device ID: 345678    Device PIN: 307654', style: TextStyle(color: Colors.grey, fontSize: 12)),
                Text('11:46 PM - Fri, Feb 20', style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(String title, String subtitle, IconData icon, bool isSelected) {
    return Expanded(
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          color: const Color(0xFF121A17),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF00FF66) : Colors.transparent,
            width: 2,
          ),
          boxShadow: isSelected
              ? [BoxShadow(color: const Color(0xFF00FF66).withOpacity(0.3), blurRadius: 10, spreadRadius: 2)]
              : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFF00FF66), size: 36),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildSideCard(String title, String subtitle, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF121A17),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF00FF66), size: 24),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContinueItem(String title, String sub) {
    return Expanded(
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: const Color(0xFF121A17),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
            const SizedBox(height: 2),
            Text(sub, style: const TextStyle(color: Colors.grey, fontSize: 10)),
            const SizedBox(height: 6),
            LinearProgressIndicator(
              value: 0.6,
              backgroundColor: Colors.black,
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF00FF66)),
            )
          ],
        ),
      ),
    );
  }
}
