import 'package:flutter/material.dart';
import 'package:key_catcher/key_catcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FilledButton(
                onPressed: () {
                  KeyCatcher.init(() => print('key!'));
                },
                child: Text('start'),
              ),
              FilledButton(
                onPressed: () => KeyCatcher.dispose(),
                child: Text('stop'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
