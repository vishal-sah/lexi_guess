import 'package:flutter/material.dart';
import 'package:lexi_guess/lexiguess/models/letter_model.dart';

class BoardTile extends StatelessWidget {
  const BoardTile({super.key, required this.letter});

  final Letter letter;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: letter.backgroundColor,
        border: Border.all(
          color: letter.borderColor,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          letter.value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}