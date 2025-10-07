import 'package:flutter/material.dart';
import 'dart:math';

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

  late List<_SpookyObject> _objects;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);

    _objects = [
      _SpookyObject('assets/images/bat.png', 80),
      _SpookyObject('assets/images/bat.png', 60),
      _SpookyObject('assets/images/pumpkin.jpeg', 100),
      _SpookyObject('assets/images/owl.png', 90),
      _SpookyObject('assets/images/ghost1.png', 120),
    ];
  }

  Widget _buildSpookyObject(_SpookyObject obj, int index, Size size) {
    final double dx = sin((_controller.value * 2 * pi) + index) * 100 +
        _random.nextDouble() * size.width * 0.8;
    final double dy = cos((_controller.value * 2 * pi) + index) * 60 +
        _random.nextDouble() * size.height * 0.8;

    return Positioned(
      left: dx,
      top: dy,
      child: Transform.rotate(
        angle: _controller.value * 2 * pi,
        child: Opacity(
          opacity: 0.6 + 0.4 * sin(_controller.value * 2 * pi),
          child: Image.asset(obj.asset, width: obj.size),
        ),
      ),
    );
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _SpookyObject {
  final String asset;
  final double size;
  _SpookyObject(this.asset, this.size);
}
