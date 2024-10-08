import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

void main() => runApp(XylophoneApp());

class XylophoneApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: XylophoneHome(),
    );
  }
}

class XylophoneHome extends StatefulWidget {
  @override
  _XylophoneHomeState createState() => _XylophoneHomeState();
}

class _XylophoneHomeState extends State<XylophoneHome> {
  final player = AudioPlayer();
  List<Color> keyColors = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
  ];
  List<int> soundNumbers = [1, 2, 3, 4, 5, 6, 7];

  void playSound(int soundNumber) {
    player.play(AssetSource('note$soundNumber.wav'));
  }

  void openColorPicker(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Pick a color for Key ${index + 1}'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: keyColors[index],
              onColorChanged: (color) {
                setState(() {
                  keyColors[index] = color;
                });
              },
            ),
          ),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Expanded buildKey({required Color color, required int soundNumber, required int index}) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          playSound(soundNumber);
          setState(() {
            // Visual feedback logic (optional: animation or color change)
          });
        },
        onLongPress: () {
          openColorPicker(index);
        },
        child: Container(
          color: color,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customized Xylophone'),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: List.generate(7, (index) {
          return buildKey(
            color: keyColors[index],
            soundNumber: soundNumbers[index],
            index: index,
          );
        }),
      ),
    );
  }
}
