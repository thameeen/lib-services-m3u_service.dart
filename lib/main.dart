import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
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
  String selectedCategory = 'LiveTV';
  bool isLoadingChannels = true;
  List> channelsList = [];

  @override
  void initState() {
    super.initState();
    _fetchFreeChannels();
  }

  // جلب القنوات المجانية من مصدر IPTV-Org الشهير
  Future<void> _fetchFreeChannels() async {
    try {
      // جلب عينة من القنوات الإخبارية والرياضية المجانية المتاحة علماً
      final response = await http.get(Uri.parse('https://iptv-org.github.io/iptv/index.channels.json'));
      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        setState(() {
          channelsList = data.take(50).map((channel) {
            return {
              "title": channel['name']?.toString() ?? 'قناة غير معروفة',
              "logo": channel['logo']?.toString() ?? '',
              "url": channel['url']?.toString() ?? 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
            };
          }).toList();
          isLoadingChannels = false;
        });
      }
    } catch (e) {
      setState(() {
        // روابط بديلة للاختبار في حال انقطع النت المؤقت
        channelsList = [
          {"title": "Big Buck Bunny (HD)", "logo": "", "url": "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"},
          {"title": "Tears of Steel (4K)", "logo": "", "url": "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4"},
        ];
        isLoadingChannels = false;
      });
    }
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
              // شريط العلوى للتطبيق
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
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Color(0xFF121A17),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Text(
                          'IPTV-Org Free Stream',
                          style: TextStyle(color: Colors.greenAccent, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    onPressed: () {
                      setState(() => isLoadingChannels = true);
                      _fetchFreeChannels();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // أقسام القنوات والأفلام
              Row(
                children: [
                  Expanded(child: _buildCategoryCard('Live TV Streams', 'Free Global Channels', Icons.tv, 'LiveTV')),
                  const SizedBox(width: 15),
                  Expanded(child: _buildCategoryCard('VOD Movies', 'Sample Media', Icons.movie, 'Movies')),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'القنوات الحية المتاحة (Live Channels):',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 10),
              // قائمة القنوات
              Expanded(
                child: isLoadingChannels
                    ? const Center(child: CircularProgressIndicator(color: Color(0xFF00FF66)))
                    : GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 3.2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: channelsList.length,
                        itemBuilder: (context, index) {
                          final channel = channelsList[index];
                          return InkWell(
                            onTap: () => _playVideo(channel['title']!, channel['url']!),
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF121A17),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: const Color(0xFF00FF66).withOpacity(0.3)),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              child: Row(
                                children: [
                                  const Icon(Icons.play_circle_fill, color: Color(0xFF00FF66), size: 28),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      channel['title']!,
                                      style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
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
      ),
    );
  }

  Widget _buildCategoryCard(String title, String subtitle, IconData icon, String categoryKey) {
    bool isSelected = selectedCategory == categoryKey;
    return Container(
      height: 90,
      decoration: BoxDecoration(
        color: const Color(0xFF121A17),
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
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
              Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 10)),
            ],
          ),
        ],
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
