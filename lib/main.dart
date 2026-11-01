import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]).then((_) {
    runApp(const HeedarTVApp());
  });
}

class HeedarTVApp extends StatelessWidget {
  const HeedarTVApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Heedar TV',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF070A09),
        primaryColor: const Color(0xFF00FF66),
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
  String selectedMainTab = 'LiveTV';
  final TextEditingController _playlistController = TextEditingController(
    text: 'https://rckestxy.xyz:80',
  );

  // نافذة الإعدادات المتقدمة لإدخال السيرفر
  void _openSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF121A17),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFF00FF66), width: 1.5),
        ),
        title: const Text('إعدادات سيرفر IPTV / Xtream', style: TextStyle(color: Color(0xFF00FF66), fontSize: 18)),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('أدخل رابط السيرفر أو ملف M3U:', style: TextStyle(color: Colors.white, fontSize: 13)),
              const SizedBox(height: 10),
              TextField(
                controller: _playlistController,
                style: const TextStyle(color: Colors.white, fontSize: 13),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF070A09),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  hintText: 'http://example.com:80',
                  hintStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(Icons.link, color: Color(0xFF00FF66)),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00FF66)),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم حفظ وتحديث السيرفر بنجاح!'), duration: Duration(seconds: 2)),
              );
            },
            child: const Text('حفظ واتصال', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // نافذة البحث السريع
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
        content: SizedBox(
          width: 400,
          child: TextField(
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFF070A09),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              hintText: 'اكتب اسم المحتوى...',
              hintStyle: const TextStyle(color: Colors.grey),
              prefixIcon: const Icon(Icons.search, color: Color(0xFF00FF66)),
            ),
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

  void _playVideo(String title, String videoUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPlayerScreen(title: title, videoUrl: videoUrl),
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
              // الشريط العلوي الاحترافي
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Text(
                        'HEEDAR TV',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF00FF66),
                          letterSpacing: 2,
                        ),
                      ),
                      SizedBox(width: 15),
                      Text(
                        'Global Smart TV Edition',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(icon: const Icon(Icons.search, color: Colors.white), onPressed: _openSearch),
                      IconButton(
                        icon: const Icon(Icons.refresh, color: Colors.white),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('جاري مزامنة القنوات...'), duration: Duration(seconds: 1)),
                          );
                        },
                      ),
                      IconButton(icon: const Icon(Icons.settings, color: Colors.white), onPressed: _openSettings),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 15),

              // الأقسام الكبرى للتحكم (Live TV, Movies, Series)
              Row(
                children: [
                  Expanded(child: _buildMainCategoryCard('Live TV', 'البث المباشر', Icons.tv, 'LiveTV')),
                  const SizedBox(width: 15),
                  Expanded(child: _buildMainCategoryCard('Movies', 'الأفلام', Icons.movie, 'Movies')),
                  const SizedBox(width: 15),
                  Expanded(child: _buildMainCategoryCard('Series', 'المسلسلات', Icons.video_library, 'Series')),
                ],
              ),
              const SizedBox(height: 20),

              // عنوان القائمة
              Text(
                selectedMainTab == 'LiveTV' ? 'قنوات البث المباشر المتاحة:' : 'مكتبة المحتوى والوسائط:',
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 10),

              // شبكة المحتوى
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: 3.8,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  children: _getMediaListForTab(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainCategoryCard(String title, String subtitle, IconData icon, String tabKey) {
    bool isSelected = selectedMainTab == tabKey;
    return InkWell(
      onTap: () {
        setState(() {
          selectedMainTab = tabKey;
        });
      },
      child: Container(
        height: 75,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0B2618) : const Color(0xFF121A17),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? const Color(0xFF00FF66) : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFF00FF66), size: 26),
            const SizedBox(width: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: isSelected ? const Color(0xFF00FF66) : Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 10)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _getMediaListForTab() {
    if (selectedMainTab == 'LiveTV') {
      return [
        _buildChannelCard('قناة الرياضة الحية 1 [HD]', 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4'),
        _buildChannelCard('قناة الرياضة الحية 2 [HD]', 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4'),
        _buildChannelCard('قناة الأخبار العالمية [FHD]', 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4'),
        _buildChannelCard('قناة المنوعات العامة [HD]', 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4'),
      ];
    } else if (selectedMainTab == 'Movies') {
      return [
        _buildChannelCard('فيلم الحركة والمغامرة [4K]', 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4'),
        _buildChannelCard('فيلم الكوميديا والدراما [HD]', 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4'),
      ];
    } else {
      return [
        _buildChannelCard('مسلسل الحلقة الأولى [Ep 1]', 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4'),
        _buildChannelCard('مسلسل الحلقة الثانية [Ep 2]', 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4'),
      ];
    }
  }

  Widget _buildChannelCard(String title, String url) {
    return InkWell(
      onTap: () => _playVideo(title, url),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF121A17),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFF00FF66).withOpacity(0.4)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            const Icon(Icons.play_circle_fill, color: Color(0xFF00FF66), size: 26),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final String title;
  final String videoUrl;

  const VideoPlayerScreen({super.key, required this.title, required this.videoUrl});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        if (mounted) {
          setState(() {
            _isInitialized = true;
          });
          _controller.play();
        }
      });
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(widget.title, style: const TextStyle(color: Color(0xFF00FF66))),
        iconTheme: const IconThemeData(color: Color(0xFF00FF66)),
      ),
      body: Center(
        child: _isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : const CircularProgressIndicator(color: Color(0xFF00FF66)),
      ),
    );
  }
}
