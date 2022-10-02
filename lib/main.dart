import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_frame/flutter_web_frame.dart';
import 'package:particle/button_list.dart';
import 'package:particle/config/colors.dart';
import 'package:particle/game.dart';
// ignore: unused_import
import 'dart:developer' as log;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterWebFrame(
      maximumSize: const Size(500, 10),
      backgroundColor: Colors.blueGrey,
      enabled: kIsWeb,
      builder: (context) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Particle Early Acces',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const MyHomePage(title: 'Particle Early Acces'),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.bg,
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          TextButton(
            child: Icon(
              (theme.settings == "dark")
                  ? Icons.light_mode_outlined
                  : Icons.light_mode,
              color: theme.otherBg,
            ),
            onPressed: () => {
              if (theme.settings == "light")
                {
                  setState(() {
                    theme.setDark();
                  }),
                }
              else
                {
                  setState(() {
                    theme.setLight();
                  }),
                },
            },
          )
        ],
      ),
      body: const Center(child: ButtonListView()),
    );
  }
}

class LaunchGame extends StatefulWidget {
  final String level;
  final String name;

  const LaunchGame(this.level, this.name, {super.key});

  @override
  State<LaunchGame> createState() => _LaunchGameState();
}

class _LaunchGameState extends State<LaunchGame> {
  late final MainGame _game;
  @override
  void initState() {
    super.initState();
    _game = MainGame(widget.level);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.name)),
      body: GameWidget(game: _game),
    );
  }
}
