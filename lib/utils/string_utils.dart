class StringUtils {
  static String capitalizeWords(String text) {
    return text
        .split(' ')
        .map(
          (word) =>
              word.isEmpty ? word : word[0].toUpperCase() + word.substring(1),
        )
        .join(' ');
  }

  static String takeFirstWords(String text, int maxWords) {
    final words = text.split(' ');
    return words.take(maxWords).join(' ');
  }

  static String ellipsize(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return text.substring(0, maxLength - 3).trimRight() + '...';
  }

  static String getInitials(String fullName, {int max = 2}) {
    final words = fullName.trim().split(RegExp(r'\s+'));
    final initials = words.take(max).map((w) => w[0].toUpperCase()).join();
    return initials;
  }
}
