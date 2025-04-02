import 'package:intl/intl.dart';

class DateUtils {
  // Year - Month - Day
  static String formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(date);
  }
}
