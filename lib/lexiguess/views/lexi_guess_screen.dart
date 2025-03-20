import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lexi_guess/lexiguess/data/word_list.dart';
import 'package:lexi_guess/lexiguess/models/letter_model.dart';
import 'package:lexi_guess/lexiguess/models/word_model.dart';
import 'package:lexi_guess/lexiguess/widgets/board.dart';
import 'package:lexi_guess/lexiguess/widgets/keyboard.dart';

enum GameStatus { playing, submitting, won, lost }

class LexiGuessScreen extends StatefulWidget {
  const LexiGuessScreen({super.key});

  @override
  State<LexiGuessScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<LexiGuessScreen> {
  GameStatus _gameStatus = GameStatus.playing;

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

  final Set<Letter> _keyboardLetters = {};

  void _onKeyTapped(String key) {
    if (_gameStatus == GameStatus.playing) {
      setState(() => _currWord?.addLetter(key));
    }
  }

  void _onDeleteTapped() {
    if (_gameStatus == GameStatus.playing) {
      setState(() => _currWord?.removeLetter());
    }
  }

  void _onEnterTapped() {
    if (_gameStatus == GameStatus.playing &&
        _currWord != null &&
        !_currWord!.letters.contains(Letter.empty())) {
      _gameStatus = GameStatus.submitting;

      for (var i = 0; i < _currWord!.letters.length; i++) {
        final currWordLetter = _currWord!.letters[i];
        final currSolutionLetter = _solution.letters[i];

        setState(() {
          if (currWordLetter == currSolutionLetter) {
            _currWord!.letters[i] = currWordLetter.copyWith(
              status: LetterStatus.correct,
            );
          } else if (_solution.letters.contains(currWordLetter)) {
            _currWord!.letters[i] = currWordLetter.copyWith(
              status: LetterStatus.inWord,
            );
          } else {
            _currWord!.letters[i] = currWordLetter.copyWith(
              status: LetterStatus.outWord,
            );
          }
        });
      }

      _checkWinOrLoss();
    }
  }

  void _checkWinOrLoss() {
    if (_currWord!.wordString == _solution.wordString) {
      _gameStatus = GameStatus.won;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          dismissDirection: DismissDirection.none,
          duration: const Duration(days: 1),
          backgroundColor: Colors.green,
          content: const Text(
            'You won!',
            style: TextStyle(color: Colors.white),
          ),
          action: SnackBarAction(
            onPressed: _restartGame,
            label: 'New Game',
            textColor: Colors.white,
          ),
        ),
      );
    } else if (_currWordIndex + 1 >= _board.length) {
      _gameStatus = GameStatus.lost;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          dismissDirection: DismissDirection.none,
          duration: const Duration(days: 1),
          backgroundColor: Colors.red,
          content: Text(
            'You lost! Solution: ${_solution.wordString}',
            style: TextStyle(color: Colors.white),
          ),
          action: SnackBarAction(
            onPressed: _restartGame,
            label: 'New Game',
            textColor: Colors.white,
          ),
        ),
      );
    } else {
      _gameStatus = GameStatus.playing;
    }
    _currWordIndex++;
  }

  void _restartGame() {
    setState(() {
      _gameStatus = GameStatus.playing;
      _currWordIndex = 0;
      _board
        ..clear()
        ..addAll(
          List.generate(
            6,
            (_) => Word(letters: List.generate(5, (_) => Letter.empty())),
          ),
        );
      _solution = Word.fromString(
        fiveLetterWords[Random().nextInt(fiveLetterWords.length)].toUpperCase(),
      );
    });
  }

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
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Board(board: _board),
          const SizedBox(height: 80),
          Keyboard(
            onKeyTapped: _onKeyTapped,
            onDeleteTapped: _onDeleteTapped,
            onEnterTapped: _onEnterTapped,
            letters: _keyboardLetters,
          ),
        ],
      ),
    );
  }
}
