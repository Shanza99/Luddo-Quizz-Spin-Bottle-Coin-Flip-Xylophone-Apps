import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Customizable Xylophone',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(), // Start with the SplashScreen
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
    // Navigate to the Xylophone app after a delay
    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => XylophoneApp()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/xy.gif'), // Load your GIF here
      ),
    );
  }
}

class XylophoneApp extends StatefulWidget {
  @override
  _XylophoneAppState createState() => _XylophoneAppState();
}

class _XylophoneAppState extends State<XylophoneApp> {
  final player = AudioPlayer();

  // Initial Colors for the keys
  List<Color> keyColors = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
  ];

  // List to store sound numbers assigned to each key
  List<int> soundNumbers = [1, 2, 3, 4, 5, 6, 7];

  // Function to play sound
  Future<void> playSound(int soundNumber) async {
    await player.setAsset('assets/note$soundNumber.wav');
    player.play();
  }

  // Function to build a customizable key
  Widget buildKey({required int soundNumber, required Color color, required int index}) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          playSound(soundNumber);
        },
        child: Container(
          color: color,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Music Note Icon
              GestureDetector(
                onTap: () => showSoundPicker(index),
                child: Icon(Icons.music_note, size: 30, color: Colors.white),
              ),
              SizedBox(width: 10), // Spacing between icon and text
              // Display the key's number
              Text(
                'Key ${index + 1}',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              SizedBox(width: 10), // Spacing between text and color icon
              // Paint Palette Icon
              GestureDetector(
                onTap: () => showColorPicker(index),
                child: Icon(Icons.color_lens, size: 30, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to show Color Picker
  void showColorPicker(int keyIndex) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Color selectedColor = keyColors[keyIndex]; // Get the current color of the key
        return AlertDialog(
          title: Text('Select Color for Key ${keyIndex + 1}'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                // Color Picker Widget
                BlockPicker(
                  pickerColor: selectedColor,
                  onColorChanged: (Color color) {
                    setState(() {
                      keyColors[keyIndex] = color; // Update the color of the key
                    });
                    Navigator.of(context).pop(); // Close dialog after color selection
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Function to show Sound Picker
  void showSoundPicker(int keyIndex) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Sound for Key ${keyIndex + 1}'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                // List of sound options
                for (int i = 1; i <= 7; i++)
                  ListTile(
                    title: Text('Sound $i'),
                    onTap: () {
                      setState(() {
                        soundNumbers[keyIndex] = i; // Update the sound number for the key
                      });
                      Navigator.of(context).pop(); // Close dialog after sound selection
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customizable Xylophone'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Xylophone keys with icons
          for (int i = 0; i < 7; i++)
            buildKey(
              soundNumber: soundNumbers[i],
              color: keyColors[i],
              index: i,
            ),
        ],
      ),
    );
  }
}
