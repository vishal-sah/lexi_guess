import 'package:flutter/material.dart';
import 'package:lexi_guess/lexiguess/views/lexi_guess_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lexi Guess',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: Colors.black),
      home: const LexiGuessScreen(),
    );
  }
}