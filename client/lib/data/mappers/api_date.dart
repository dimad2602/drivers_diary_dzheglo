/// День для query-параметра `date` (`YYYY-MM-DD`), без времени и часового пояса.
String formatApiDate(DateTime date) {
  String two(int v) => v.toString().padLeft(2, '0');
  return '${date.year.toString().padLeft(4, '0')}-${two(date.month)}-${two(date.day)}';
}
