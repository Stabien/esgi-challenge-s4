import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

String transformerDate(String dateString) {
  initializeDateFormatting('fr', null);
  DateTime date = DateTime.parse(dateString);

  // Formater le mois uniquement
  String monthFormatted =
      DateFormat('MMMM', 'fr').format(DateTime(date.year, date.month));

  // Formater la date dans le format "dd MMM yyyy"
  String formattedDate =
      '${DateFormat('dd', 'fr').format(date)} ${monthFormatted.substring(0, 3)} ${DateFormat('yyyy', 'fr').format(date)}';

  return formattedDate;
}

String traduireDate(String dateString) {
  // Format de la date d'entrée
  DateFormat inputFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
  // Date parsée à partir de la chaîne de date
  DateTime date = inputFormat.parse(dateString);

  // Format de la date de sortie
  DateFormat outputFormat = DateFormat("dd/MM/yy - HH:mm:ss");
  // Traduction de la date en format localisé
  String formattedDate = outputFormat.format(date);

  return formattedDate;
}
