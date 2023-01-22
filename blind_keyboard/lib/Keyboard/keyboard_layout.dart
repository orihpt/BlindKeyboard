class KeyboardLayout {
  late final List<List<String>> layout;

  late final String languageCode;

  // Initializer that get language as string.
  KeyboardLayout(String language) {
    languageCode = language;
    // Switch language
    switch (language) {
      case 'he':
        layout = [
          ['ק', 'ר', 'א', 'ט', 'ו', 'ן', 'ם', 'פ'],
          ['ש', 'ד', 'ג', 'כ', 'ע', 'י', 'ח', 'ל', 'ך', 'ף'],
          ['ז', 'ס', 'ב', 'ה', 'נ', 'מ', 'צ', 'ת']
        ];
        break;
      case 'en':
        layout = [
          ['q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p'],
          ['a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l'],
          ['z', 'x', 'c', 'v', 'b', 'n', 'm']
        ];
        break;
      default:
        throw Exception('Language not supported');
    }
  }
}
