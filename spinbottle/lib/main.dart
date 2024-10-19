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
  
  Color selectedColor = Colors.deepPurple; // Default color
  String selectedFont = 'Lobster'; // Default font

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    );

    _animation = Tween<double>(begin: 0.0, end: 2 * pi * 10).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Spin the Bottle',
          style: TextStyle(fontFamily: selectedFont, fontSize: 28, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [selectedColor, selectedColor.withOpacity(0.7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Color Selection
              DropdownButton<Color>(
                value: selectedColor,
                onChanged: (Color? newColor) {
                  if (newColor != null) {
                    setState(() {
                      selectedColor = newColor;
                    });
                  }
                },
                items: <DropdownMenuItem<Color>>[
                  DropdownMenuItem(
                    value: Colors.deepPurple,
                    child: Text('Deep Purple'),
                  ),
                  DropdownMenuItem(
                    value: Colors.blue,
                    child: Text('Blue'),
                  ),
                  DropdownMenuItem(
                    value: Colors.red,
                    child: Text('Red'),
                  ),
                  DropdownMenuItem(
                    value: Colors.green,
                    child: Text('Green'),
                  ),
                ],
              ),
              // Font Selection
              DropdownButton<String>(
                value: selectedFont,
                onChanged: (String? newFont) {
                  if (newFont != null) {
                    setState(() {
                      selectedFont = newFont;
                    });
                  }
                },
                items: <DropdownMenuItem<String>>[
                  DropdownMenuItem(
                    value: 'Lobster',
                    child: Text('Lobster'),
                  ),
                  DropdownMenuItem(
                    value: 'Times New Roman',
                    child: Text('Times New Roman'),
                  ),
                  DropdownMenuItem(
                    value: 'Georgia',
                    child: Text('Georgia'),
                  ),
                ],
              ),
              SizedBox(height: 20),
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
                        'assets/bottle.png',
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: MediaQuery.of(context).size.height * 0.2,
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 10),
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
              Container(
                height: MediaQuery.of(context).size.height * 0.2,
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
                          fontFamily: selectedFont,
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
              ElevatedButton(
                onPressed: spinBottle,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.deepPurple,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Spin the Bottle!',
                  style: TextStyle(fontSize: 22, fontFamily: selectedFont),
                ),
              ),
              SizedBox(height: 10),
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
                          fontFamily: selectedFont,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Challenge: ${challenges[Random().nextInt(challenges.length)]}',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white70,
                          fontFamily: selectedFont,
                        ),
                      ),
                    ],
                  ),
                ),
              SizedBox(height: 10),
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
    );
  }
}
