import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:management_rack/services/log_service.dart';
import 'package:management_rack/models/log_model.dart';
import 'package:intl/intl.dart';


class PdfService {
  static Future<void> generateAndPrintPDF() async {
    final pdf = pw.Document();
    final logs = await LogService.ambilGlobalLog();
    final dateFormat = DateFormat('dd MMM yyyy - HH:mm');

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Text('Riwayat Transaksi', style: pw.TextStyle(fontSize: 24)),
          pw.SizedBox(height: 20),
          ...logs.reversed.map((log) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(dateFormat.format(log.waktu), style: pw.TextStyle(fontSize: 12, color: PdfColors.grey)),
              pw.Text(log.aksi, style: pw.TextStyle(fontSize: 14)),
              pw.SizedBox(height: 12),
            ],
          ))
        ],
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }
}