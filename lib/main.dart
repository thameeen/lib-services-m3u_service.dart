import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
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

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String selectedCategory = 'Movies';
  String serverUrl = 'http://example.com:8080/get.php?username=...';

  // نافذة إعدادات فخمة ومتكاملة
  void _openSettings() {
    TextEditingController urlController = TextEditingController(text: serverUrl);
    
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: const Color(0xFF121A17),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFF00FF66), width: 1.5),
        ),
        child: Container(
          width: 600,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.settings, color: Color(0xFF00FF66), size: 28),
                  SizedBox(width: 12),
                  Text('إعدادات النظام - Heedar TV', style: TextStyle(color: Color(0xFF00FF66), fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
              const Divider(color: Colors.grey, height: 25),
              
              const Text('رابط سيرفر البث (Xtream API / M3U):', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: urlController,
                style: const TextStyle(color: Colors.white, fontSize: 13),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF070A09),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF00FF66))),
                  hintText: 'http://...',
                  hintStyle: const TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 20),

              const Text('معلومات الجهاز:', style: TextStyle(color: Colors.grey, fontSize: 12)),
              const SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF070A09),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Device ID: 345678', style: TextStyle(color: Colors.white, fontSize: 12)),
                    Text('Mac Address: AA:BB:CC:DD:EE', style: TextStyle(color: Colors.white, fontSize: 12)),
                  ],
                ),
              ),
              const SizedBox(height: 25),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('إلغاء', style: TextStyle(color: Colors.grey)),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00FF66),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    onPressed: () {
                      setState(() {
                        serverUrl = urlController.text;
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('تم حفظ إعدادات السيرفر بنجاح!'), duration: Duration(seconds: 2)),
                      );
                    },
                    child: const Text('حفظ التغييرات', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // نافذة البحث
  void _openSearch() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF121A17),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFF00FF66), width: 1.5),
        ),
        title: const Text('بحث عن قناة أو فيلم', style: TextStyle(color: Color(0xFF00FF66), fontSize: 18)),
        content: TextField(
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF070A09),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            hintText: 'اكتب اسم المحتوى للبحث...',
            hintStyle: const TextStyle(color: Colors.grey),
            prefixIcon: const Icon(Icons.search, color: Color(0xFF00FF66)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق', style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
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
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF00FF66),
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF121A17),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFF00FF66).withOpacity(0.5)),
                        ),
                        child: const Text(
                          'Free Trial - 5 Days Left',
                          style: TextStyle(color: Color(0xFF00FF66), fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(icon: const Icon(Icons.search, color: Colors.white), onPressed: _openSearch),
                      IconButton(icon: const Icon(Icons.replay, color: Colors.white), onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('جاري تحديث البيانات...')));
                      }),
                      IconButton(icon: const Icon(Icons.settings, color: Colors.white), onPressed: _openSettings),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 20),

              // الأقسام الرئيسية
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: [
                        Expanded(child: _buildCategoryCard('Live TV\'s', '+5000 Channels', Icons.tv, 'LiveTV')),
                        const SizedBox(width: 15),
                        Expanded(child: _buildCategoryCard('Movies', '+12000 Movies', Icons.movie, 'Movies')),
                        const SizedBox(width: 15),
                        Expanded(child: _buildCategoryCard('Series', '+7000 Series', Icons.video_library, 'Series')),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        _buildSideCard('Favorites', '422 Items', Icons.favorite, () {}),
                        const SizedBox(height: 10),
                        _buildSideCard('Playlists', '1 Playlist', Icons.playlist_play, () {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Current Playlist: Global Heedar Mix')));
                        }),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),

              // قسم متابعة المشاهدة
              const Text(
                'Continue Watching',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: _buildContinueItem('Dark City Chronicles', 'Season 2 - Episode 8')),
                  const SizedBox(width: 15),
                  Expanded(child: _buildContinueItem('La Casa De Papel', 'Season 4 - Episode 3')),
                  const SizedBox(width: 15),
                  Expanded(child: _buildContinueItem('Lilo & Stitch', '2023')),
                ],
              ),
              const Spacer(),

              // الشريط السفلي ومعلومات الجهاز
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Device ID: 345678    Device PIN: 307654', style: TextStyle(color: Colors.grey, fontSize: 11)),
                  Text('11:46 PM - Fri, Feb 20', style: TextStyle(color: Colors.grey, fontSize: 11)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(String title, String subtitle, IconData icon, String categoryKey) {
    bool isSelected = selectedCategory == categoryKey;
    return InkWell(
      onTap: () {
        setState(() {
          selectedCategory = categoryKey;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تم الانتقال إلى قسم: $title'), duration: const Duration(milliseconds: 800)),
        );
      },
      child: Container(
        height: 130,
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
            Icon(icon, color: const Color(0xFF00FF66), size: 32),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _buildSideCard(String title, String subtitle, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF121A17),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF00FF66), size: 22),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 11)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContinueItem(String title, String sub) {
    return InkWell(
      onTap: () {},
      child: Container(
        height: 85,
        decoration: BoxDecoration(
          color: const Color(0xFF121A17),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
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
