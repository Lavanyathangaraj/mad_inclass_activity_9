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

class _SpookyPageState extends State<SpookyPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Random _random = Random();

  List<Offset> _positions = [];

  @override
  void initState() {
    super.initState();
    _generateInitialPositions();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 5))
          ..addListener(() {
            if (_controller.status == AnimationStatus.completed) {
              _generateNewPositions();
              _controller.repeat();
            }
            setState(() {});
          })
          ..repeat();
  }

  void _generateInitialPositions() {
    _positions = List.generate(6, (_) {
      return Offset(
        _random.nextDouble(),
        _random.nextDouble(),
      );
    });
  }

  void _generateNewPositions() {
    _positions = List.generate(6, (_) {
      return Offset(
        _random.nextDouble(),
        _random.nextDouble(),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _animatedObject(int index, String asset, double size) {
    final dx = _positions[index].dx;
    final dy = _positions[index].dy;

    return AnimatedPositioned(
      duration: const Duration(seconds: 5),
      curve: Curves.easeInOut,
      left: dx * MediaQuery.of(context).size.width,
      top: dy * MediaQuery.of(context).size.height,
      child: Opacity(
        opacity: 0.8 + 0.2 * sin(_controller.value * 2 * pi),
        child: Image.asset(asset, width: size),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
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
          Stack(
            children: [
              _animatedObject(0, 'assets/images/bat.png', 80),
              _animatedObject(1, 'assets/images/bat.png', 70),
              _animatedObject(2, 'assets/images/pumpkin.jpeg', 90),
              _animatedObject(3, 'assets/images/pumpkin.jpeg', 100),
              _animatedObject(4, 'assets/images/owl.png', 85),
              _animatedObject(5, 'assets/images/ghost1.png', 95),
            ],
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              "🦇 TRAPSSSS!! 🦇",
              style: TextStyle(
                color: Colors.orangeAccent.withOpacity(0.9),
                fontSize: 24,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(blurRadius: 15, color: Colors.orangeAccent),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
