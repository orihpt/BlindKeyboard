class Word {
  late final String word;
  late final double? dist;

  // # Constructors
  Word(this.word, this.dist);

  Word.combine(Word a, Word b) {
    word = a.word + b.word;
    dist = a.dist! + b.dist!;
  }

  Word.nothing() {
    word = "";
    dist = null;
  }
}
