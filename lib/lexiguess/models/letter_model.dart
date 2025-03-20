import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:lexi_guess/app/app_colors.dart';

enum LetterStatus {
  initial,
  correct,
  inWord,
  outWord,
}

class Letter extends Equatable {
  const Letter({
    required this.value,
    this.status = LetterStatus.initial,
  });

  factory Letter.empty() => const Letter(value: '');

  final String value;
  final LetterStatus status;

  Color get backgroundColor {
    switch (status) {
      case LetterStatus.correct:
        return correctColor;
      case LetterStatus.inWord:
        return inWordColor;
      case LetterStatus.outWord:
        return outWordColor;
      default:
        return Colors.transparent;
    }
  }

  Color get borderColor {
    switch (status) {
      case LetterStatus.initial:
        return Colors.grey;
      default:
        return Colors.transparent;
    }
  }

  Letter copyWith({
    String? value,
    LetterStatus? status,
  }) {
    return Letter(
      value: value ?? this.value,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [value, status];
}