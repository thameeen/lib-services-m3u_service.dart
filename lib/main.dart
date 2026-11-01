import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const HeedarTVApp());
}

class HeedarTVApp extends StatelessWidget {
  const HeedarTVApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HEEDAR TV',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F0F0F),
        primaryColor: Colors.greenAccent,
        colorScheme: const ColorScheme.dark(
          primary: Colors.greenAccent,
          secondary: Colors.greenAccent,
        ),
      ),
      home: const LoginServerScreen(),
    );
  }
}

class LoginServerScreen extends StatefulWidget {
  const LoginServerScreen({Key? key}) : super(key: key);

  @override
  State<LoginServerScreen> createState() => _LoginServerScreenState();
}

class _LoginServerScreenState extends State<LoginServerScreen> {
  final _serverController = TextEditingController();
  final _userController = TextEditingController();
  final _passController = TextEditingController();
  bool _isLoading = false;

  void _connectToServer() {
    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainHomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 450),
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: const Color(0xFF181818),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.greenAccent.withOpacity(0.3), width: 1.5),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.tv_rounded, size: 60, color: Colors.greenAccent),
                const SizedBox(height: 15),
                const Text(
                  'HEEDAR TV',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.5),
                ),
                const SizedBox(height: 5),
                const Text(
                  'أدخل بيانات السيرفر الحقيقي للبدء',
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: _serverController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Server URL (e.g. http://xtream.com:8080)',
                    labelStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                    prefixIcon: const Icon(Icons.link, color: Colors.greenAccent),
                    filled: true,
                    fillColor: const Color(0xFF222222),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _userController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Username',
                    labelStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                    prefixIcon: const Icon(Icons.person, color: Colors.greenAccent),
                    filled: true,
                    fillColor: const Color(0xFF222222),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _passController,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                    prefixIcon: const Icon(Icons.lock, color: Colors.greenAccent),
                    filled: true,
                    fillColor: const Color(0xFF222222),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: _isLoading ? null : _connectToServer,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.black)
                        : const Text(
                            'ربط السيرفر ودخول التطبيق',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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
          style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold, fontSize: 22),
        ),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.greenAccent),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Server Connected Active',
              style: TextStyle(color: Colors.greenAccent, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 15),
          IconButton(icon: const Icon(Icons.search, color: Colors.white), onPressed: () {}),
          IconButton(icon: const Icon(Icons.refresh, color: Colors.white), onPressed: () {}),
          IconButton(icon: const Icon(Icons.settings, color: Colors.white), onPressed: () {}),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildMenuCard(
                    context,
                    title: "Live TV's",
                    subtitle: "Channels & Sports",
                    icon: Icons.tv,
                    isHighlighted: true,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const InternalLiveTvScreen()));
                    },
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _buildMenuCard(
                    context,
                    title: "Movies",
                    subtitle: "VOD Library",
                    icon: Icons.movie,
                    isHighlighted: false,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const InternalMoviesScreen()));
                    },
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _buildMenuCard(
                    context,
                    title: "Series",
                    subtitle: "Seasons & Episodes",
                    icon: Icons.video_library,
                    isHighlighted: false,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const InternalSeriesScreen()));
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 35),
            const Text(
              'Continue Watching',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(child: _buildMediaCard(title: "Dark City Chronicles", subtitle: "S2 - Ep 8", progress: 0.7)),
                const SizedBox(width: 15),
                Expanded(child: _buildMediaCard(title: "La Casa De Papel", subtitle: "S4 - Ep 3", progress: 0.4)),
                const SizedBox(width: 15),
                Expanded(child: _buildMediaCard(title: "Lilo & Stitch", subtitle: "2023", progress: 0.9)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, {required String title, required String subtitle, required IconData icon, required VoidCallback onTap, bool isHighlighted = false}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 130,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF181818),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isHighlighted ? Colors.greenAccent : Colors.transparent, width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.greenAccent, size: 32),
            const Spacer(),
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaCard({required String title, required String subtitle, required double progress}) {
    return Container(
      height: 110,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: const Color(0xFF181818), borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white), maxLines: 1),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.grey), maxLines: 1),
          const SizedBox(height: 10),
          LinearProgressIndicator(value: progress, backgroundColor: Colors.grey[800], valueColor: const AlwaysStoppedAnimation<Color>(Colors.greenAccent)),
        ],
      ),
    );
  }
}

class InternalLiveTvScreen extends StatelessWidget {
  const InternalLiveTvScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Live TV Channels', style: TextStyle(color: Colors.greenAccent)), backgroundColor: const Color(0xFF0F0F0F)),
      body: ListView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: 15,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.tv, color: Colors.greenAccent),
            title: Text('Channel ${index + 1}', style: const TextStyle(color: Colors.white)),
            subtitle: const Text('Server Live Stream Ready', style: TextStyle(color: Colors.grey)),
            trailing: const Icon(Icons.play_circle_fill, color: Colors.greenAccent, size: 30),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const VideoPlayerScreen(videoUrl: "https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4")));
            },
          );
        },
      ),
    );
  }
}

class InternalMoviesScreen extends StatelessWidget {
  const InternalMoviesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Movies VOD Library', style: TextStyle(color: Colors.greenAccent)), backgroundColor: const Color(0xFF0F0F0F)),
      body: GridView.builder(
        padding: const EdgeInsets.all(15),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5, childAspectRatio: 0.65, crossAxisSpacing: 12, mainAxisSpacing: 12),
        itemCount: 20,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const VideoPlayerScreen(videoUrl: "https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4")));
            },
            child: Container(
              decoration: BoxDecoration(color: const Color(0xFF181818), borderRadius: BorderRadius.circular(8)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.movie, size: 40, color: Colors.greenAccent),
                  const SizedBox(height: 10),
                  Text('Movie ${index + 1}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class InternalSeriesScreen extends StatelessWidget {
  const InternalSeriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Series Library', style: TextStyle(color: Colors.greenAccent)), backgroundColor: const Color(0xFF0F0F0F)),
      body: GridView.builder(
        padding: const EdgeInsets.all(15),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5, childAspectRatio: 0.65, crossAxisSpacing: 12, mainAxisSpacing: 12),
        itemCount: 15,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const VideoPlayerScreen(videoUrl: "https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4")));
            },
            child: Container(
              decoration: BoxDecoration(color: const Color(0xFF181818), borderRadius: BorderRadius.circular(8)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.video_library, size: 40, color: Colors.greenAccent),
                  const SizedBox(height: 10),
                  Text('Series ${index + 1}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;
  const VideoPlayerScreen({Key? key, required this.videoUrl}) : super(key: key);

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        setState(() {
          _isInitialized = true;
          _controller.play();
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: Center(
        child: _isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : const CircularProgressIndicator(color: Colors.greenAccent),
      ),
    );
  }
}
