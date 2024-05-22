import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

String transformerDate(String dateString) {
  initializeDateFormatting('fr', null);
  DateTime date = DateTime.parse(dateString);

  // Formater le mois uniquement
  String monthFormatted = DateFormat('MMMM', 'fr').format(DateTime(date.year, date.month));

  // Formater la date dans le format "dd MMM yyyy"
  String formattedDate = '${DateFormat('dd', 'fr').format(date)} ${monthFormatted.substring(0, 3)} ${DateFormat('yyyy', 'fr').format(date)}';

  return formattedDate;
}

// void main() {
//   String dateTransformed = transformerDate("2024-07-15T00:00:00Z");
//   print(dateTransformed); // Output: 19 juil 2024
// }
