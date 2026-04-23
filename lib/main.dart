import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Binaural Beats',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: ThemeData.dark(useMaterial3: true),
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
      ),
      home: const HomePage(),
    );
  }
}

// ================= MODEL =================
class Song {
  final String title;
  final String artist;
  final String audio;
  final String image;

  Song({
    required this.title,
    required this.artist,
    required this.audio,
    required this.image,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      title: json['title'],
      artist: json['artist'] ?? 'Unknown Artist',
      audio: json['audio'],
      image: json['image'],
    );
  }
}

// ================= LOCAL JSON (Fallback) =================
const String localJson = '''
[
  {
    "title": "Activate Chakras",
    "artist": "by Aarav Sharma",
    "audio": "https://res.cloudinary.com/dvvbfvvl1/video/upload/v1766592225/music-1_o9uo5v.mp3",
    "image": "https://res.cloudinary.com/dvvbfvvl1/image/upload/v1768987856/music-1_e1flnn.jpg"
  },
  {
    "title": "Astral Travel",
    "artist": "by Rohan Verma",
    "audio": "https://res.cloudinary.com/dvvbfvvl1/video/upload/v1766592216/music-2_sek9cu.mp3",
    "image": "https://res.cloudinary.com/dvvbfvvl1/image/upload/v1768987856/music-2_loowfa.jpg"
  },
  {
    "title": "Brain Booster",
    "artist": "by Ananya Iyer",
    "audio": "https://res.cloudinary.com/dvvbfvvl1/video/upload/v1766591976/music-3_xyxoy2.mp3",
    "image": "https://res.cloudinary.com/dvvbfvvl1/image/upload/v1768987856/music-3_ib4f1t.jpg"
  },
  {
    "title": "Brain Massage",
    "artist": "by Kunal Mehta",
    "audio": "https://res.cloudinary.com/dvvbfvvl1/video/upload/v1766592231/music-4_q6q0lh.mp3",
    "image": "https://res.cloudinary.com/dvvbfvvl1/image/upload/v1768987858/music-4_dimtab.jpg"
  },
  {
    "title": "Buddha",
    "artist": "by Siddharth Rao",
    "audio": "https://res.cloudinary.com/dvvbfvvl1/video/upload/v1766592136/music-5_jtvqmp.mp3",
    "image": "https://res.cloudinary.com/dvvbfvvl1/image/upload/v1768987859/music-5_byq9i7.jpg"
  },
  {
    "title": "Concentration",
    "artist": "by Neha Kulkarni",
    "audio": "https://res.cloudinary.com/dvvbfvvl1/video/upload/v1766592150/music-6_h5dfuc.mp3",
    "image": "https://res.cloudinary.com/dvvbfvvl1/image/upload/v1768987858/music-6_zuldqt.jpg"
  },
  {
    "title": "Ekagraman",
    "artist": "by Arjun Patel",
    "audio": "https://res.cloudinary.com/dvvbfvvl1/video/upload/v1766592167/music-7_abluqr.mp3",
    "image": "https://res.cloudinary.com/dvvbfvvl1/image/upload/v1768987858/music-7_nhdolu.jpg"
  },
  {
    "title": "Euphoria",
    "artist": "by Pooja Nair",
    "audio": "https://res.cloudinary.com/dvvbfvvl1/video/upload/v1766592210/music-8_le9dvd.mp3",
    "image": "https://res.cloudinary.com/dvvbfvvl1/image/upload/v1768987860/music-8_nsy7sf.jpg"
  },
  {
    "title": "Feel Good",
    "artist": "by Aman Khanna",
    "audio": "https://res.cloudinary.com/dvvbfvvl1/video/upload/v1766592166/music-9_xi0ydi.mp3",
    "image": "https://res.cloudinary.com/dvvbfvvl1/image/upload/v1768987858/music-9_e0t025.jpg"
  },
  {
    "title": "Healing",
    "artist": "by Kavya Joshi",
    "audio": "https://res.cloudinary.com/dvvbfvvl1/video/upload/v1766592176/music-10_qswcvt.mp3",
    "image": "https://res.cloudinary.com/dvvbfvvl1/image/upload/v1768987858/music-10_l19zg4.jpg"
  },
  {
    "title": "Meditation",
    "artist": "by Rahul Sengupta",
    "audio": "https://res.cloudinary.com/dvvbfvvl1/video/upload/v1766592152/music-11_nmoh1k.mp3",
    "image": "https://res.cloudinary.com/dvvbfvvl1/image/upload/v1768987858/music-11_aq4np4.jpg"
  },
  {
    "title": "Mindfulness",
    "artist": "by Sneha Banerjee",
    "audio": "https://res.cloudinary.com/dvvbfvvl1/video/upload/v1766592039/music-12_asw12t.mp3",
    "image": "https://res.cloudinary.com/dvvbfvvl1/image/upload/v1768987859/music-12_hyewyf.jpg"
  },
  {
    "title": "Manifesting",
    "artist": "by Aditya Malhotra",
    "audio": "https://res.cloudinary.com/dvvbfvvl1/video/upload/v1766592017/music-13_ebrbuc.mp3",
    "image": "https://res.cloudinary.com/dvvbfvvl1/image/upload/v1768987859/music-13_m8flut.jpg"
  },
  {
    "title": "Yes you can",
    "artist": "by Aditya Malhotra",
    "audio": "https://res.cloudinary.com/dvvbfvvl1/video/upload/v1766592021/music-14_lyzfaq.mp3",
    "image": "https://res.cloudinary.com/dvvbfvvl1/image/upload/v1768987859/music-14_qx4l6a.jpg"
  },
  {
    "title": "Mantras",
    "artist": "by Aditya Malhotra",
    "audio": "https://res.cloudinary.com/dvvbfvvl1/video/upload/v1766592171/music-15_gnetua.mp3",
    "image": "https://res.cloudinary.com/dvvbfvvl1/image/upload/v1768995054/music-15_knwzss.png"
  },
  {
    "title": "Natraja",
    "artist": "by Aditya Malhotra",
    "audio": "https://res.cloudinary.com/dvvbfvvl1/video/upload/v1766592161/music-16_ksya1g.mp3",
    "image": "https://res.cloudinary.com/dvvbfvvl1/image/upload/v1768987859/music-16_uopwn4.jpg"
  },
  {
    "title": "Negative Aura",
    "artist": "by Nikhil Arora",
    "audio": "https://res.cloudinary.com/dvvbfvvl1/video/upload/v1766592223/music-17_gz9esg.mp3",
    "image": "https://res.cloudinary.com/dvvbfvvl1/image/upload/v1768987861/music-17_p5pjjj.jpg"
  },
  {
    "title": "OM 432Hz",
    "artist": "by Nikhil Arora",
    "audio": "https://res.cloudinary.com/dvvbfvvl1/video/upload/v1766592175/music-18_blpoo1.mp3",
    "image": "https://res.cloudinary.com/dvvbfvvl1/image/upload/v1768987860/music-18_fviuqg.jpg"
  },
  {
    "title": "Powerful Thoughts",
    "artist": "by Ritu Saxena",
    "audio": "https://res.cloudinary.com/dvvbfvvl1/video/upload/v1766592183/music-19_aguv69.mp3",
    "image": "https://res.cloudinary.com/dvvbfvvl1/image/upload/v1768987859/music-19_oxv4iy.jpg"
  },
  {
    "title": "Rain Sound",
    "artist": "by Ritu Saxena",
    "audio": "https://res.cloudinary.com/dvvbfvvl1/video/upload/v1766592182/music-20_a5nmnf.mp3",
    "image": "https://res.cloudinary.com/dvvbfvvl1/image/upload/v1768987862/music-20_eejmbh.jpg"
  },
  {
    "title": "Gratitude",
    "artist": "by Saurabh Mishra",
    "audio": "https://res.cloudinary.com/dvvbfvvl1/video/upload/v1766592072/music-21_rxfurd.mp3",
    "image": "https://res.cloudinary.com/dvvbfvvl1/image/upload/v1768987860/music-21_y7z1jt.jpg"
  },
  {
    "title": "Samadhi",
    "artist": "by Saurabh Mishra",
    "audio": "https://res.cloudinary.com/dvvbfvvl1/video/upload/v1766592235/music-22_c3nfib.mp3",
    "image": "https://res.cloudinary.com/dvvbfvvl1/image/upload/v1768987860/music-22_ikihpe.jpg"
  },
  {
    "title": "Sleep",
    "artist": "by Isha Chatterjee",
    "audio": "https://res.cloudinary.com/dvvbfvvl1/video/upload/v1766592098/music-23_s1m63p.mp3",
    "image": "https://res.cloudinary.com/dvvbfvvl1/image/upload/v1768987856/music-23_wi9leo.jpg"
  },
  {
    "title": "3rd Eye",
    "artist": "by Isha Chatterjee",
    "audio": "https://res.cloudinary.com/dvvbfvvl1/video/upload/v1766592233/music-24_wic3o7.mp3",
    "image": "https://res.cloudinary.com/dvvbfvvl1/image/upload/v1768987857/music-24_ps2pbo.jpg"
  },
  {
    "title": "Vipassana",
    "artist": "by Devansh Gupta",
    "audio": "https://res.cloudinary.com/dvvbfvvl1/video/upload/v1766592104/music-25_wovdq0.mp3",
    "image": "https://res.cloudinary.com/dvvbfvvl1/image/upload/v1768987857/music-25_eulsep.jpg"
  },
  {
    "title": "Visualize",
    "artist": "by Devansh Gupta",
    "audio": "https://res.cloudinary.com/dvvbfvvl1/video/upload/v1766592205/music-26_zoowsj.mp3",
    "image": "https://res.cloudinary.com/dvvbfvvl1/image/upload/v1768987858/music-26_qevdvf.jpg"
  },
  {
    "title": "Yog Nidra",
    "artist": "by Devansh Gupta",
    "audio": "https://res.cloudinary.com/dvvbfvvl1/video/upload/v1766592230/music-27_du9nnp.mp3",
    "image": "https://res.cloudinary.com/dvvbfvvl1/image/upload/v1768987858/music-27_tmmi9e.jpg"
  }
]
''';

// ================= HOME PAGE =================
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Song> songs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSongs();
  }

  Future<void> fetchSongs() async {
    try {
      final res = await http.get(Uri.parse("YOUR_JSON_LINK"));

      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        songs = data.map<Song>((e) => Song.fromJson(e)).toList();
      } else {
        throw Exception("API failed");
      }
    } catch (e) {
      final data = json.decode(localJson);
      songs = data.map<Song>((e) => Song.fromJson(e)).toList();
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Binaural Beats"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      drawer: Drawer(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  DrawerHeader(
                    margin: EdgeInsets.zero,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            "https://images.pexels.com/photos/6985201/pexels-photo-6985201.jpeg?_gl=1*19t0a4r*_ga*MTE0NjU2MzYxMi4xNzY4ODE3NzE5*_ga_8JE65Q40S6*czE3NzYxODMzNzIkbzgkZzEkdDE3NzYxODM1NjQkajI5JGwwJGgw",
                            fit: BoxFit.cover,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black.withOpacity(0.15),
                                  Colors.black.withOpacity(0.55),
                                ],
                              ),
                            ),
                          ),
                          const Align(
                            alignment: Alignment.bottomLeft,
                            child: Padding(
                              padding: EdgeInsets.all(18),
                              child: Text(
                                "Binaural Beats",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.music_note),
                    title: const Text("All Songs"),
                    onTap: () => Navigator.pop(context),
                  ),
                  ListTile(
                    leading: const Icon(Icons.info),
                    title: const Text("About"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AboutPage()),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Text(
                      "💎",
                      style: TextStyle(fontSize: 28),
                    ),
                    title: const Text("Exclusive"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LinksPage()),
                      );
                    },
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 12, 20, 28),
              child: Text(
                "Made By ❤️ India",
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 14,
                  letterSpacing: 0.4,
                ),
              ),
            ),
          ],
        ),
      ),

      // 🌈 PREMIUM BACKGROUND
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F0F1A), Color(0xFF1A1A2E)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: songs.length,
                itemBuilder: (_, i) {
                  final song = songs[i];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PlayerPage(song: song),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 18),
                      height: 108,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22),
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.08),
                            Colors.white.withOpacity(0.02),
                          ],
                        ),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.08),
                        ),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 8),

                          // 🎵 IMAGE
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              song.image,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),

                          const SizedBox(width: 16),

                          // 🎶 TITLE
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  song.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  song.artist,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white.withOpacity(0.68),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // ▶️ PLAY BUTTON
                          Container(
                            margin: const EdgeInsets.only(right: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [Colors.deepPurple, Colors.blue],
                              ),
                            ),
                            child: const Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

// ================= PLAYER =================
class PlayerPage extends StatefulWidget {
  final Song song;
  const PlayerPage({super.key, required this.song});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  final AudioPlayer player = AudioPlayer();
  bool isLoop = false;
  bool isLoadingAudio = true;

  @override
  void initState() {
    super.initState();
    _loadAudio();
  }

  Future<void> _loadAudio() async {
    try {
      await player.setUrl(widget.song.audio);
    } finally {
      if (mounted) {
        setState(() => isLoadingAudio = false);
      }
    }
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  Future<void> togglePlay() async {
    if (isLoadingAudio) return;

    if (player.playing) {
      await player.pause();
    } else {
      await player.play();
    }
  }

  void toggleLoop() {
    setState(() {
      isLoop = !isLoop;
      player.setLoopMode(isLoop ? LoopMode.one : LoopMode.off);
    });
  }

  String formatTime(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 10),

            // 🎵 Album Art
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.network(widget.song.image, height: 240),
            ),

            const SizedBox(height: 20),

            Text(
              widget.song.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              widget.song.artist,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                color: Colors.white.withOpacity(0.68),
                fontWeight: FontWeight.w400,
              ),
            ),

            const SizedBox(height: 40),

            // 🎚 SLIDER (FIXED)
            StreamBuilder<Duration>(
              stream: player.positionStream,
              builder: (_, snapshot) {
                final position = snapshot.data ?? Duration.zero;

                return StreamBuilder<Duration?>(
                  stream: player.durationStream,
                  builder: (_, snapshot2) {
                    final duration = snapshot2.data ?? Duration.zero;

                    return Column(
                      children: [
                        Slider(
                          value: position.inSeconds.toDouble(),
                          max: duration.inSeconds.toDouble() == 0
                              ? 1
                              : duration.inSeconds.toDouble(),
                          onChanged: (value) {
                            player.seek(Duration(seconds: value.toInt()));
                          },
                          activeColor: Colors.deepPurple,
                          inactiveColor: Colors.grey,
                        ),

                        // ⏱ TIME TEXT
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(formatTime(position)),
                            Text(formatTime(duration)),
                          ],
                        ),
                      ],
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 30),

            // 🎮 CONTROLS
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ▶️ Play Button
                GestureDetector(
                  onTap: togglePlay,
                  child: StreamBuilder<PlayerState>(
                    stream: player.playerStateStream,
                    builder: (_, snapshot) {
                      final playerState = snapshot.data;
                      final isPlaying = playerState?.playing ?? false;
                      final processingState = playerState?.processingState;
                      final showSpinner =
                          isLoadingAudio ||
                          processingState == ProcessingState.loading ||
                          processingState == ProcessingState.buffering;

                      return Container(
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [Colors.deepPurple, Colors.blue],
                          ),
                        ),
                        child: showSpinner
                            ? const SizedBox(
                                width: 40,
                                height: 40,
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : Icon(
                                isPlaying ? Icons.pause : Icons.play_arrow,
                                size: 40,
                                color: Colors.white,
                              ),
                      );
                    },
                  ),
                ),
                
                const SizedBox(width: 30),

                // 🔁 Loop Button
                GestureDetector(
                  onTap: toggleLoop,
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isLoop ? Colors.deepPurple : Colors.grey[800],
                    ),
                    child: Icon(
                      isLoop ? Icons.repeat_one : Icons.repeat,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),

            const Spacer(),

            // 👇 FOOTER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Wear 🎧",
                  style: TextStyle(color: Colors.grey),
                ),
                TextButton(
                  onPressed: () {
                    launchUrl(Uri.parse("https://www.youtube.com/@mr.informative"));
                  },
                  child: const Text("Visit YouTube 🔗"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ================= ABOUT =================
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("About")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "Binaural beats are a form of sound therapy where two different tones are played separately in each ear, leading the brain to interpret a subtle rhythmic beat. This perceived beat can help guide the mind into specific states such as calmness, deep focus or restful sleep. Often used with headphones, binaural beats are popular for enhancing meditation, reducing stress, and improving overall mental well-being. ",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                launchUrl(Uri.parse("https://rzp.io/rzp/4jG77z1"));
              },
              child: const Text("Donate ❤️"),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= LINKS =================
class _LinkItem {
  final String label;
  final String subtitle;
  final String url;
  final IconData? icon;
  final String? symbol;
  final List<Color> colors;

  const _LinkItem({
    required this.label,
    required this.subtitle,
    required this.url,
    this.icon,
    this.symbol,
    required this.colors,
  });
}

class LinksPage extends StatelessWidget {
  const LinksPage({super.key});

  final List<_LinkItem> links = const [
    _LinkItem(
      label: "Website",
      subtitle: "Official website of Mr Informative 🧿",
      url: "https://www.youtube.com/@mr.informative",
      icon: Icons.language_rounded,
      colors: [Color(0xFF4B6CB7), Color(0xFF182848)],
    ),
    _LinkItem(
      label: "Instagram",
      subtitle: "Watch reels from here 🎞️",
      url: "https://www.instagram.com/mrinformative/",
      symbol: "📷",
      colors: [Color(0xFFFF9966), Color(0xFFFF5E62)],
    ),
    _LinkItem(
      label: "Products",
      subtitle: "Visit more from us! 🛍️",
      url: "https://vaibhavvkumarr.github.io/mrinfor",
      symbol: "🛍️",
      colors: [Color(0xFF11998E), Color(0xFF38EF7D)],
    ),
    _LinkItem(
      label: "Developer 👨🏻‍💻",
      subtitle: "Come Say Hey!",
      url: "https://www.instagram.com/vaibhavvkumar/",
      symbol: "🐍",
      colors: [Color(0xFF11998E), Color(0xFF38EF7D)],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Links"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0C0B14), Color(0xFF17142A), Color(0xFF0B101D)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            children: [
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.10),
                      Colors.white.withOpacity(0.04),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(color: Colors.white.withOpacity(0.08)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Stay connected",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Open the places where listeners can explore, follow and visit the products.",
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.5,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              ...links.map((link) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(26),
                    boxShadow: [
                      BoxShadow(
                        color: link.colors.first.withOpacity(0.20),
                        blurRadius: 24,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(26),
                      onTap: () => launchUrl(Uri.parse(link.url)),
                      child: Ink(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(26),
                          gradient: LinearGradient(
                            colors: [
                              link.colors.first.withOpacity(0.30),
                              Colors.white.withOpacity(0.05),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.08),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(colors: link.colors),
                              ),
                              child: Center(
                                child: link.symbol != null
                                    ? Text(
                                        link.symbol!,
                                        style: const TextStyle(fontSize: 28),
                                      )
                                    : Icon(link.icon, color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    link.label,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    link.subtitle,
                                    style: const TextStyle(
                                      fontSize: 13.5,
                                      height: 1.4,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Icon(
                                Icons.open_in_new_rounded,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
