abstract class UtilityFunctions {
  static String? extractNumber(String input) {
    RegExp regExp = RegExp(r'\d+');

    Match? match = regExp.firstMatch(input);

    return match?.group(0);
  }

  static bool isBase64Image(String base64String) {
    // Define the regular expression for Base64 image strings
    final RegExp base64ImagePattern = RegExp(
        r'^data:image/(jpeg|jpg|png|gif);base64,[a-zA-Z0-9+/]+={0,2}$');

    return base64ImagePattern.hasMatch(base64String);
  }

  static String? extractImageType(String input) {
    RegExp regExp = RegExp(r'(jpeg|jpg|png|gif)');

    Match? match = regExp.firstMatch(input);

    return match?.group(0);
  }
}

extension SafeSubstring on String {
  String safeSubstring({int start=0, int? end}) {
    final endValue = end!=null
        ? end > this.length ? this.length : end
        : this.length;

    if (start > endValue) {
      return '';
    }
    return this.substring(start, endValue);
  }
}