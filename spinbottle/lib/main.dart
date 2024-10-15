import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(SpinBottleApp());

class SpinBottleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spin the Bottle Game',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: SpinBottleHomePage(),
    );
  }
}

class SpinBottleHomePage extends StatefulWidget {
  @override
  _SpinBottleHomePageState createState() => _SpinBottleHomePageState();
}

class _SpinBottleHomePageState extends State<SpinBottleHomePage>
    with SingleTickerProviderStateMixin {
  final List<String> players = [];
  final List<String> challenges = [
    "Do a silly dance for 10 seconds.",
    "Tell a funny joke.",
    "Share a secret.",
    "Imitate someone in the group.",
    "Do 10 push-ups.",
    "Sing a song of your choice.",
    "Do a cartwheel.",
    "Give a compliment to the person next to you.",
    "Speak in an accent for the next turn.",
    "Do your best impression of a celebrity."
  ];
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool isSpinning = false;
  String selectedPlayer = '';
  final TextEditingController playerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    );

    final curvedAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: 2 * pi * 10,
    ).animate(curvedAnimation)
      ..addListener(() {
        setState(() {
          // Animation update for bottle rotation
        });
      });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Spin the bottle with gradual slowing down
  void spinBottle() {
    if (players.isEmpty || isSpinning) return;

    setState(() {
      isSpinning = true;
      _animationController.forward(from: 0);
    });

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        int selectedIndex =
            (_animation.value / (2 * pi) * players.length).round() %
                players.length;
        setState(() {
          selectedPlayer = players[selectedIndex];
          isSpinning = false;
        });
      }
    });
  }

  // Add player
  void addPlayer() {
    if (playerController.text.isNotEmpty && players.length < 10) {
      setState(() {
        players.add(playerController.text);
        playerController.clear();
      });
    }
  }

  // Clear players
  void clearPlayers() {
    setState(() {
      players.clear();
      selectedPlayer = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Spin the Bottle',
          style: TextStyle(
            fontFamily: 'Cursive',
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: screenHeight, // Dynamically adjust height to screen size
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Bottle display with glowing animation
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _animation.value,
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.6),
                              spreadRadius: 5,
                              blurRadius: 15,
                              offset: Offset(0, 0),
                            ),
                          ],
                        ),
                        child: Image.asset(
                          'assets/bottle.png', // Use the bottle image asset
                          width: screenWidth * 0.4, // Responsive width
                          height: screenHeight * 0.2, // Responsive height
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 10),
                // Player input field
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: playerController,
                    decoration: InputDecoration(
                      labelText: 'Enter Player Name',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.add),
                        onPressed: addPlayer,
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                // List of players
                Container(
                  height: screenHeight * 0.2, // Set height for the player list
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: players.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          players[index],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () {
                            setState(() {
                              players.removeAt(index);
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 10),
                // Spin button with animation
                ElevatedButton(
                  onPressed: spinBottle,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.deepPurple, padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shadowColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Spin the Bottle!',
                    style: TextStyle(fontSize: 22, fontFamily: 'Cursive'),
                  ),
                ),
                SizedBox(height: 10),
                // Selected player display with glow effect
                if (selectedPlayer.isNotEmpty)
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.purpleAccent,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 15,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Selected Player: $selectedPlayer',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Challenge: ${challenges[Random().nextInt(challenges.length)]}',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                SizedBox(height: 10),
                // Clear players button
                ElevatedButton(
                  onPressed: clearPlayers,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Clear Players',
                    style: TextStyle(fontSize: 20),
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
