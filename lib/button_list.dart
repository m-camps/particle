import 'package:flutter/material.dart';
import 'package:particle/config/colors.dart';
import 'package:particle/config/globals.dart';
import 'package:particle/main.dart';

class ButtonListView extends StatelessWidget {
  const ButtonListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: const [
        LevelButton("assets/levels/level1.json", "dev"),
        LevelButton("assets/levels/precision_level.json", "Precision"),
        LevelButton("assets/levels/speed_level.json", "Speed"),
        LevelButton("assets/levels/timing_level.json", "Timing"),
      ],
    );
  }
}

class LevelButton extends StatefulWidget {
  final String level;
  final String name;
  const LevelButton(this.level, this.name, {super.key});

  @override
  State<LevelButton> createState() => _LevelButtonState();
}

class _LevelButtonState extends State<LevelButton> {
  late String highscore;

  @override
  void initState() {
    highscore = (global.highscores[widget.name] == null)
        ? "0"
        : global.highscores[widget.name].toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      color: theme.otherBg,
      child: ListTile(
        trailing: Text("Highscore: $highscore"),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      LaunchGame(widget.level, widget.name))).then((value) => {
                setState(() {
                  highscore = global.highscores[widget.name].toString();
                })
              });
        },
        title: Text(
          widget.name,
          style: TextStyle(color: theme.bg, fontSize: 30),
        ),
      ),
    );
  }
}
