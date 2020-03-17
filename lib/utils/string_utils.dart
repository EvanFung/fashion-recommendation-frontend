class StringUtils {
  static bool isUrl(String payback) {
    RegExp exp = new RegExp(
        r"(https?|ftp)://([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?");
    return exp.hasMatch(payback);
  }
}
