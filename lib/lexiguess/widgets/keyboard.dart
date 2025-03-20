import 'package:flutter/material.dart';
import 'package:lexi_guess/lexiguess/lexiguess.dart';
import 'package:lexi_guess/lexiguess/models/letter_model.dart';

const _querty = [
  ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'],
  ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'],
  ['DEL', 'Z', 'X', 'C', 'V', 'B', 'N', 'M', 'GUESS'],
];

class Keyboard extends StatelessWidget {
  const Keyboard({
    super.key,
    required this.onKeyTapped,
    required this.onDeleteTapped,
    required this.onEnterTapped,
    required this.letters,
  });

  final void Function(String) onKeyTapped;
  final VoidCallback onDeleteTapped;
  final VoidCallback onEnterTapped;
  final Set<Letter> letters;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children:
          _querty
              .map(
                (keyRow) => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:
                      keyRow.map((letter) {
                        if (letter == 'DEL') {
                          return _KeyboardButton.delete(onTap: onDeleteTapped);
                        } else if (letter == 'GUESS') {
                          return _KeyboardButton.enter(onTap: onEnterTapped);
                        }

                        final letterKey = letters.firstWhere(
                          (element) => element.value == letter,
                          orElse: () => Letter.empty(),
                        );

                        return _KeyboardButton(
                          onTap: () => onKeyTapped(letter),
                          letter: letter,
                          backgroundColor:
                              letterKey != Letter.empty()
                                  ? letterKey.backgroundColor
                                  : Colors.grey,
                        );
                      }).toList(),
                ),
              )
              .toList(),
    );
  }
}

class _KeyboardButton extends StatelessWidget {
  const _KeyboardButton({
    this.height = 48,
    this.width = 30,
    required this.onTap,
    required this.backgroundColor,
    required this.letter,
  });

  factory _KeyboardButton.delete({required VoidCallback onTap}) =>
      _KeyboardButton(
        width: 60,
        onTap: onTap,
        backgroundColor: Colors.red,
        letter: 'DEL',
      );

  factory _KeyboardButton.enter({required VoidCallback onTap}) =>
      _KeyboardButton(
        width: 60,
        onTap: onTap,
        backgroundColor: Colors.green,
        letter: 'GUESS',
      );

  final double height;
  final double width;
  final VoidCallback onTap;
  final Color backgroundColor;
  final String letter;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 2.0),
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
        child: InkWell(
          onTap: onTap,
          child: Container(
            height: height,
            width: width,
            alignment: Alignment.center,
            child: Text(
              letter,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
