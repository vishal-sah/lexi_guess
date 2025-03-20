import 'dart:math';

import 'package:flip_card/flip_card.dart';
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
  State<LexiGuessScreen> createState() => _LexiGuessScreenState();
}

class _LexiGuessScreenState extends State<LexiGuessScreen> {
  GameStatus _gameStatus = GameStatus.playing;

  final List<Word> _board = List.generate(
    6,
    (_) => Word(letters: List.generate(5, (_) => Letter.empty())),
  );

  final List<List<GlobalKey<FlipCardState>>> _flipCardKeys = List.generate(
    6,
    (_) => List.generate(5, (_) => GlobalKey<FlipCardState>()),
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

  Future<void> _onEnterTapped() async {
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

        final letter = _keyboardLetters.firstWhere(
          (element) => element.value == currWordLetter.value,
          orElse: () => Letter.empty(),
        );

        if (letter.status != LetterStatus.correct) {
          _keyboardLetters.removeWhere(
            (element) => element.value == currWordLetter.value,
          );
          _keyboardLetters.add(_currWord!.letters[i]);
        }

        await Future.delayed(
          const Duration(milliseconds: 150),
          () => _flipCardKeys[_currWordIndex][i].currentState?.toggleCard(),
        );
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
      _flipCardKeys
        ..clear()
        ..addAll(
          List.generate(
            6,
            (_) => List.generate(5, (_) => GlobalKey<FlipCardState>()),
          ),
        );
      _keyboardLetters.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;

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
          SizedBox(
            height: screenHeight * 0.15,
            child: Center(
              child: Text(
                'Guess the word!',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(
            height: screenHeight * 0.45,
            child: Board(board: _board, flipCardKeys: _flipCardKeys),
          ),
          SizedBox(
            height: screenHeight * 0.25,
            child: Keyboard(
              onKeyTapped: _onKeyTapped,
              onDeleteTapped: _onDeleteTapped,
              onEnterTapped: _onEnterTapped,
              letters: _keyboardLetters,
            ),
          ),
          SizedBox(height: screenHeight * 0.02),
        ],
      ),
    );
  }
}
