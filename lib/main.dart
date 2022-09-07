import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'collision.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: const Center(
        child: MyGamePage(),
      ),
    );
  }
}

class MyGamePage extends StatefulWidget {
  const MyGamePage({super.key});

  @override
  State<MyGamePage> createState() => _MyGamePageState();
}

class _MyGamePageState extends State<MyGamePage> {
  late final CirclesExample _game;

  @override
  void initState() {
    super.initState();
    _game = CirclesExample();
  }

  @override
  Widget build(BuildContext context) {
    return GameWidget(game: _game);
  }
}
