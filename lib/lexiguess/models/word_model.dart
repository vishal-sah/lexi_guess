import 'package:equatable/equatable.dart';
import 'package:lexi_guess/lexiguess/lexiguess.dart';

class Word extends Equatable {
  const Word({
    required this.letters,
  });

  factory Word.fromString(String word) => Word(letters: word.split('').map((e) => Letter(value: e)).toList());

  final List<Letter> letters;

  String get wordString => letters.map((e) => e.value).join();

  void addLetter(String value) {
    final currIndex = letters.indexWhere((element) => element.value.isEmpty);
    if (currIndex != -1) {
      letters[currIndex] = Letter(value: value);
    }
  }

  void removeLetter() {
    final currIndex = letters.indexWhere((element) => element.value.isNotEmpty);
    if (currIndex != -1) {
      letters[currIndex] = Letter.empty();
    }
  }

  @override
  List<Object?> get props => [letters];
}