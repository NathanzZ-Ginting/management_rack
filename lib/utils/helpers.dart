import 'package:intl/intl.dart';

String formatRupiah(double angka) {
  final format = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);
  return format.format(angka);
}