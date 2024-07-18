import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

String transformerDate(String dateString) {
  initializeDateFormatting('fr', null);
  DateTime date = DateTime.parse(dateString);

  String monthFormatted =
      DateFormat('MMMM', 'fr').format(DateTime(date.year, date.month));

  String formattedDate =
      '${DateFormat('dd', 'fr').format(date)} ${monthFormatted.substring(0, 3)} ${DateFormat('yyyy', 'fr').format(date)}';

  return formattedDate;
}

String traduireDateEvent(String dateString) {
  DateTime dateTime = DateTime.parse(dateString);
  DateFormat dateFormat = DateFormat('dd/MM/yyyy HH:mm');
  String formattedDate = dateFormat.format(dateTime);

  return formattedDate;
}

String traduireDate(String dateString) {
  DateTime dateTime = DateTime.parse(dateString);
  DateFormat dateFormat = DateFormat('dd/MM/yyyy HH:mm:ss');
  String formattedDate = dateFormat.format(dateTime);

  return formattedDate;
}
