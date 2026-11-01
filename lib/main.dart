import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

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
  String selectedCategory = 'movies';
  Map<String, dynamic>? serverData;

  // رابط السيرفر السحابي الخاص بك على GitHub
  final String serverJsonUrl = 'https://raw.githubusercontent.com/thameeen/lib-services-m3u_service.dart/refs/heads/main/heedar_server.json';

  @override
  void initState() {
    super.initState();
    _fetchServerData();
  }

  Future<void> _fetchServerData() async {
    try {
      final response = await http.get(Uri.parse(serverJsonUrl));
      if (response.statusCode == 200) {
        setState(() {
          serverData = json.decode(response.body);
        });
      }
    } catch (e) {
      // الاعتماد على البيانات الافتراضية في حال وجود أي عائق بالاتصال
    }
  }

  final TextEditingController _urlController = TextEditingController(text: 'http://');
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  String loginType = 'Xtream API';

  void _openSettings() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) => Dialog(
          backgroundColor: const Color(0xFF121A17),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFF00FF66), width: 1.5),
          ),
          child: Container(
            width: 650,
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.settings, color: Color(0xFF00FF66), size: 26),
                      SizedBox(width: 10),
                      Text('إعدادات حساب الـ IPTV الاحترافية', style: TextStyle(color: Color(0xFF00FF66), fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const Divider(color: Colors.grey, height: 20),

                  const Text('طريقة الاتصال (Login Type):', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildRadioOption('Xtream API', loginType == 'Xtream API', () {
                        setStateDialog(() => loginType = 'Xtream API');
                      }),
                      const SizedBox(width: 20),
                      _buildRadioOption('M3U Playlist URL', loginType == 'M3U Playlist URL', () {
                        setStateDialog(() => loginType = 'M3U Playlist URL');
                      }),
                    ],
                  ),
                  const SizedBox(height: 15),

                  if (loginType == 'Xtream API') ...[
                    _buildTextField('اسم السيرفر أو الرابط (URL):', _urlController, 'http://provider.com:8080'),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: _buildTextField('اسم المستخدم (Username):', _userController, 'Username')),
                        const SizedBox(width: 10),
                        Expanded(child: _buildTextField('كلمة المرور (Password):', _passController, 'Password', obscure: true)),
                      ],
                    ),
                  ] else ...[
                    _buildTextField('رابط ملف M3U الكامل:', _urlController, 'http://provider.com/get.php?username=...&password=...'),
                  ],

                  const SizedBox(height: 15),
                  const Text('معلومات الجهاز:', style: TextStyle(color: Colors.grey, fontSize: 11)),
                  const SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF070A09),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Device ID: 345678', style: TextStyle(color: Colors.white, fontSize: 11)),
                        Text('Mac Address: AA:BB:CC:DD:EE', style: TextStyle(color: Colors.white, fontSize: 11)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('إلغاء', style: TextStyle(color: Colors.grey)),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00FF66),
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('تم حفظ بيانات السيرفر وجاري الاتصال بنجاح!'), duration: Duration(seconds: 2)),
                          );
                        },
                        child: const Text('تسجيل الدخول / حفظ', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRadioOption(String title, bool selected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(selected ? Icons.radio_button_checked : Icons.radio_button_unchecked, color: const Color(0xFF00FF66), size: 18),
          const SizedBox(width: 6),
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, String hint, {bool obscure = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          obscureText: obscure,
          style: const TextStyle(color: Colors.white, fontSize: 12),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF070A09),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF00FF66))),
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
        ),
      ],
    );
  }

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
    List continueWatching = serverData?['continue_watching'] ?? [
      {
        "title": "Dark City Chronicles",
        "subtitle": "Season 2 - Episode 8",
        "poster_url": "https://images.unsplash.com/photo-1536440136628-849c177e76a1?w=500"
      },
      {
        "title": "La Casa De Papel",
        "subtitle": "Season 4 - Episode 3",
        "poster_url": "https://images.unsplash.com/photo-1574375927938-d5a98e8ffe85?w=500"
      },
      {
        "title": "Lilo & Stitch",
        "subtitle": "2023",
        "poster_url": "https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=500"
      }
    ];

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
                        child: Text(
                          serverData?['notice'] ?? 'Free Trial - 5 Days Left',
                          style: const TextStyle(color: Color(0xFF00FF66), fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(icon: const Icon(Icons.search, color: Colors.white), onPressed: _openSearch),
                      IconButton(icon: const Icon(Icons.replay, color: Colors.white), onPressed: _fetchServerData),
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
                children: continueWatching.map<Widget>((item) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: _buildContinueItem(item['title'], item['subtitle'], item['poster_url']),
                    ),
                  );
                }).toList(),
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

  Widget _buildContinueItem(String title, String sub, String posterUrl) {
    return InkWell(
      onTap: () {},
      child: Container(
        height: 95,
        decoration: BoxDecoration(
          color: const Color(0xFF121A17),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            // صورة البستر الخلفية مع معالجة الأخطاء
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  posterUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(color: const Color(0xFF121A17)),
                ),
              ),
            ),
            // طبقة تظليل سوداء لضمان وضوح النصوص فوق الصورة
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black.withOpacity(0.65),
                ),
              ),
            ),
            // محتوى النصوص ومؤشر التقدم
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(title, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                  Text(sub, style: const TextStyle(color: Color(0xFF00FF66), fontSize: 10)),
                  const SizedBox(height: 6),
                  LinearProgressIndicator(
                    value: 0.6,
                    backgroundColor: Colors.black54,
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF00FF66)),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
