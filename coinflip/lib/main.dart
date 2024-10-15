import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(CoinTossApp());

class CoinTossApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coin Toss Game',
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CoinTossScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/coin.gif'), // Make sure the path is correct
      ),
    );
  }
}

class CoinTossScreen extends StatefulWidget {
  @override
  _CoinTossScreenState createState() => _CoinTossScreenState();
}

class _CoinTossScreenState extends State<CoinTossScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  String _result = '';
  bool _isTossed = false;
  bool _showResult = false;
  int _score = 0;
  String? _userChoice;
  Color _backgroundColor = Colors.white; // Default background color

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );
  }

  void _tossCoin() {
    setState(() {
      _isTossed = true;
      _showResult = false; // Hide result while tossing
      _controller.reset();
      _controller.forward();
    });

    Future.delayed(const Duration(seconds: 5), () {
      String result = Random().nextBool() ? 'Heads' : 'Tails';
      setState(() {
        _result = result;
        _showResult = true;
      });
    });
  }

  void _resetGame() {
    setState(() {
      _result = '';
      _isTossed = false;
      _showResult = false;
      _userChoice = null; // Reset user choice
    });
  }

  void _changeBackgroundColor(Color color) {
    setState(() {
      _backgroundColor = color;
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
      appBar: AppBar(
        title: Text('Coin Toss Game'),
      ),
      body: Container(
        color: _backgroundColor,
        child: Row(
          children: [
            // Color Picker
            Container(
              width: 50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => _changeBackgroundColor(Colors.red),
                    child: CircleAvatar(backgroundColor: Colors.red, radius: 20),
                  ),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: () => _changeBackgroundColor(Colors.green),
                    child: CircleAvatar(backgroundColor: Colors.green, radius: 20),
                  ),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: () => _changeBackgroundColor(Colors.blue),
                    child: CircleAvatar(backgroundColor: Colors.blue, radius: 20),
                  ),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: () => _changeBackgroundColor(Colors.yellow),
                    child: CircleAvatar(backgroundColor: Colors.yellow, radius: 20),
                  ),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: () => _changeBackgroundColor(Colors.purple),
                    child: CircleAvatar(backgroundColor: Colors.purple, radius: 20),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Coin Toss',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black, // Black button color
                    ),
                    onPressed: _tossCoin,
                    child: Text('Toss Coin', style: TextStyle(color: Colors.white)),
                  ),
                  SizedBox(height: 20),
                  if (_showResult)
                    Text(
                      'Result: $_result',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black, // Black button color
                    ),
                    onPressed: _resetGame,
                    child: Text('Reset Game', style: TextStyle(color: Colors.white)),
                  ),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(
                            0,
                            -300 * (_animation.value < 0.5
                                ? _animation.value * 2
                                : (1 - _animation.value) * 2),
                          ),
                          child: Transform.rotate(
                            angle: _animation.value * pi * 4,
                            child: Image.asset(
                              'assets/coin.png',
                              height: 100,
                              width: 100,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
