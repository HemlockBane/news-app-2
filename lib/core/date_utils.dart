import 'package:intl/intl.dart';

class DateUtil {
  static String getFormattedDate(DateTime? dateTime) {
    if (dateTime == null) return "";
    return DateFormat("MMM d, yyyy").format(dateTime);
  }
}
