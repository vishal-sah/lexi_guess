import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lexi_guess/lexiguess/data/word_list.dart';
import 'package:lexi_guess/lexiguess/models/letter_model.dart';
import 'package:lexi_guess/lexiguess/models/word_model.dart';

enum GameStatus { playing, submitting, won, lost }

class LexiGuessScreen extends StatefulWidget {
  const LexiGuessScreen({super.key});

  @override
  State<LexiGuessScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<LexiGuessScreen> {
  GameStatus gameStatus = GameStatus.playing;

  final List<Word> _board = List.generate(
    6,
    (_) => Word(letters: List.generate(5, (_) => Letter.empty())),
  );

  int _currWordIndex = 0;

  Word? get _currWord =>
      _currWordIndex < _board.length ? _board[_currWordIndex] : null;

  Word _solution = Word.fromString(
    fiveLetterWords[Random().nextInt(fiveLetterWords.length)].toUpperCase(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'LEXI GUESS',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            letterSpacing: 4,
          ),
        )
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Board(board: _board),
        ],
      ),
    );
  }
}
