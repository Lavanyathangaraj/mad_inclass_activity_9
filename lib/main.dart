import 'package:flutter/material.dart';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(HalloweenStoryApp());
}

class HalloweenStoryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Halloween Storybook',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        textTheme: ThemeData.dark().textTheme.apply(
              bodyColor: Colors.white,
              displayColor: Colors.white,
            ),
      ),
      home: IntroScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class IntroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.black],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/halloween1.webp',
                height: 250,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 30),
              const Text(
                "🎃 Welcome to the Haunted Halloween Storybook 🎃",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.orangeAccent,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                "Dare to enter the spooky world...\nPress the arrow to continue!",
                style: TextStyle(fontSize: 16, color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SpookyPage()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.orangeAccent,
                  ),
                  child: const Icon(Icons.arrow_forward, color: Colors.white, size: 30),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SpookyPage extends StatefulWidget {
  const SpookyPage({super.key});

  @override
  State<SpookyPage> createState() => _SpookyPageState();
}

class _SpookyPageState extends State<SpookyPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Random _random = Random();
  final AudioPlayer _bgmPlayer = AudioPlayer();
  final AudioPlayer _effectPlayer = AudioPlayer();
  late List<_SpookyObject> _objects;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 75),
    )..repeat(reverse: true);

    _objects = [
      _SpookyObject('assets/images/bat.png', 80, isTrap: true),
      _SpookyObject('assets/images/owl.png', 90, isTrap: true),
      _SpookyObject('assets/images/bat.png', 60, isTrap: false),
      _SpookyObject('assets/images/ghost1.png', 120, isTrap: false),
      _SpookyObject('assets/images/pumpkin.jpeg', 100, isTrap: false, isWinningItem: true),
    ];
    _playBackgroundMusic();
  }

  Future<void> _playBackgroundMusic() async {
    await _bgmPlayer.setReleaseMode(ReleaseMode.loop);
    await _bgmPlayer.play(AssetSource('sounds/bg.mp3'));
  }

  Future<void> _playEffect(String sound) async {
    await _effectPlayer.play(AssetSource('sounds/$sound'));
  }

  Widget _buildSpookyObject(_SpookyObject obj, int index, Size size) {
    final double dx = sin((_controller.value * 0.4 * pi) + index) * 100 +
        _random.nextDouble() * size.width * 0.8;
    final double dy = cos((_controller.value * 0.4 * pi) + index) * 60 +
        _random.nextDouble() * size.height * 0.8;
    final double rotationAngle = _controller.value * 0.02 * pi;

    return Positioned(
      left: dx,
      top: dy,
      child: GestureDetector(
        onTap: () {
          if (obj.isWinningItem) {
            _playEffect('safe.mp3');
            _showWinningDialog();
          } else if (obj.isTrap) {
            _playEffect('trap.mp3');
            _flashRed(obj);
          }
        },
        child: AnimatedBuilder(
          animation: _controller,
          builder: (_, __) => Transform.rotate(
            angle: rotationAngle,
            child: Opacity(
              opacity: 0.6 + 0.4 * sin(_controller.value * 2 * pi),
              child: Image.asset(obj.asset, width: obj.size),
            ),
          ),
        ),
      ),
    );
  }

  void _flashRed(_SpookyObject obj) async {
    OverlayEntry? overlay;
    overlay = OverlayEntry(
      builder: (_) => Positioned.fill(
        child: Container(color: Colors.red.withOpacity(0.4)),
      ),
    );
    Overlay.of(context).insert(overlay);
    await Future.delayed(const Duration(milliseconds: 300));
    overlay.remove();
  }

  void _showWinningDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.deepPurple[900],
        title: const Text(
          "🎉 You Found It! 🎃",
          style: TextStyle(color: Colors.orangeAccent),
        ),
        content: const Text(
          "The spirits are pleased with your bravery!",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Continue", style: TextStyle(color: Colors.orangeAccent)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _bgmPlayer.dispose();
    _effectPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final size = MediaQuery.of(context).size;
          return Stack(
            children: [
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.black, Colors.deepPurple],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
              ...List.generate(
                _objects.length,
                (index) => _buildSpookyObject(_objects[index], index, size),
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  "👻 The Spirits Awaken 👻",
                  style: TextStyle(
                    color: Colors.orangeAccent.withOpacity(0.9),
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(blurRadius: 15, color: Colors.orangeAccent),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SpookyObject {
  final String asset;
  final double size;
  final bool isTrap;
  final bool isWinningItem;
  _SpookyObject(this.asset, this.size, {this.isTrap = false, this.isWinningItem = false});
}
