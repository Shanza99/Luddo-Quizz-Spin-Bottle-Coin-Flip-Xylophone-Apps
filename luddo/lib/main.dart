import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(LudoApp());
}

class LudoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ludo Dice Game',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
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
    // Navigate to LudoGamePage after 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LudoGamePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/luddo.gif'), // Load your GIF here
      ),
    );
  }
}

class LudoGamePage extends StatefulWidget {
  @override
  _LudoGamePageState createState() => _LudoGamePageState();
}

class _LudoGamePageState extends State<LudoGamePage> with SingleTickerProviderStateMixin {
  int currentPlayer = 0;
  List<int> scores = [0, 0, 0, 0];
  List<String> playerNames = ["Player 1", "Player 2", "Player 3", "Player 4"];
  int rounds = 2;
  int currentRound = 0;
  int diceValue = 1;
  late AnimationController _diceAnimationController;
  late Animation<double> _diceAnimation;
  Color _backgroundColor = Colors.white;

  @override
  void initState() {
    super.initState();
    _diceAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _diceAnimation = CurvedAnimation(
      parent: _diceAnimationController,
      curve: Curves.elasticInOut,
    );

    _diceAnimationController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _diceAnimationController.dispose();
    super.dispose();
  }

  void rollDice() {
    if (currentRound < rounds) {
      _diceAnimationController.forward(from: 0);
      setState(() {
        diceValue = Random().nextInt(6) + 1;
        scores[currentPlayer] += diceValue;
      });

      currentPlayer = (currentPlayer + 1) % 4;
      if (currentPlayer == 0) {
        currentRound++;
      }
    } else {
      _showWinner();
    }
  }

  void _showWinner() {
    int winner = scores.indexWhere((score) => score == scores.reduce(max));
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Game Over"),
          content: Text("${playerNames[winner]} is the winner with ${scores[winner]} points!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetGame();
              },
              child: Text("Play Again"),
            ),
          ],
        );
      },
    );
  }

  void _resetGame() {
    setState(() {
      currentPlayer = 0;
      scores = [0, 0, 0, 0];
      currentRound = 0;
    });
  }

  void _changeBackgroundColor(Color color) {
    setState(() {
      _backgroundColor = color;
    });
  }

  void _changePlayerName(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController nameController = TextEditingController();
        return AlertDialog(
          title: Text("Change Name for ${playerNames[index]}"),
          content: TextField(
            controller: nameController,
            decoration: InputDecoration(hintText: "Enter new name"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  playerNames[index] = nameController.text.isNotEmpty ? nameController.text : playerNames[index];
                });
                Navigator.of(context).pop();
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ludo Dice Game'),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [_backgroundColor, Colors.deepPurpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Transform.rotate(
                        angle: _diceAnimation.value * 2 * pi,
                        child: Image.asset(
                          'assets/dice$diceValue.png',
                          width: 100,
                          height: 100,
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildPlayerButton(0),
                          _buildPlayerButton(1),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildPlayerButton(2),
                          _buildPlayerButton(3),
                        ],
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: rollDice,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                          backgroundColor: const Color.fromARGB(255, 217, 208, 234),
                        ),
                        child: Text(
                          'Roll Dice',
                          style: TextStyle(fontSize: 22),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerButton(int playerIndex) {
    bool isActive = currentPlayer == playerIndex;

    return GestureDetector(
      onTap: () => _changePlayerName(playerIndex),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isActive ? Colors.orange : Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: isActive ? Colors.orangeAccent : Colors.black12,
              spreadRadius: 4,
              blurRadius: 6,
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              playerNames[playerIndex],
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              'Score: ${scores[playerIndex]}',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
