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
                        'Android TV Dashboard',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF121A17),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFF00FF66)),
                    ),
                    child: const Text(
                      'Connected Active',
                      style: TextStyle(color: Colors.greenAccent, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),

              // الواجهة الرئيسية: الأقسام الكبرى (Live TV, Movies, Series)
              Row(
                children: [
                  Expanded(child: _buildMainCategoryCard('Live TV', 'القنوات الحية والرياضة', Icons.tv, 'LiveTV')),
                  const SizedBox(width: 15),
                  Expanded(child: _buildMainCategoryCard('Movies', 'الأفلام والمنوعات', Icons.movie, 'Movies')),
                  const SizedBox(width: 15),
                  Expanded(child: _buildMainCategoryCard('Series', 'المسلسلات الحصرية', Icons.video_library, 'Series')),
                ],
              ),
              const SizedBox(height: 20),

              // العنوان الفرعي حسب القسم المختار
              Text(
                selectedMainTab == 'LiveTV' ? 'قنوات البث المباشر المتاحة:' : 'مكتبة الوسائط والأفلام:',
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 10),

              // قائمة القنوات أو المحتوى داخل القسم
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
        height: 85,
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
            Icon(icon, color: const Color(0xFF00FF66), size: 28),
            const SizedBox(width: 12),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: isSelected ? const Color(0xFF00FF66) : Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
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
        _buildChannelCard('قناة الرياضة الحية 1 (Sports)', 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4'),
        _buildChannelCard('قناة الرياضة الحية 2 (Sports)', 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4'),
        _buildChannelCard('قناة الأخبار العالمية (News)', 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4'),
        _buildChannelCard('قناة المنوعات العامة (General)', 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4'),
      ];
    } else if (selectedMainTab == 'Movies') {
      return [
        _buildChannelCard('فيلم الحركة والمغامرة (Action)', 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4'),
        _buildChannelCard('فيلم الكوميديا والدراما (Comedy)', 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4'),
      ];
    } else {
      return [
        _buildChannelCard('مسلسل الحلقة الأولى (Ep 1)', 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4'),
        _buildChannelCard('مسلسل الحلقة الثانية (Ep 2)', 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4'),
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
        setState(() => _isInitialized = true);
        _controller.play();
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
