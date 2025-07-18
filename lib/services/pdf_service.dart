import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class PdfService {
  static Future<void> generateAndPrintPDF() async {
    final pdf = pw.Document();
    final snapshot = await FirebaseFirestore.instance
        .collection('transaksi')
        .orderBy('tanggal', descending: true)
        .get();

    final transaksiList = snapshot.docs.map((doc) => doc.data()).toList();
    final dateFormat = DateFormat('dd MMM yyyy - HH:mm');

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Text('Riwayat Transaksi', style: pw.TextStyle(fontSize: 24)),
          pw.SizedBox(height: 20),

          pw.Table.fromTextArray(
            border: null,
            cellAlignment: pw.Alignment.centerLeft,
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            headers: ['Nama Barang', 'Jumlah', 'Total', 'Tanggal'],
            data: transaksiList.map((data) {
              final nama = data['namaBarang'] ?? 'Barang';
              final jumlah = data['jumlah'].toString();
              final total = 'Rp ${data['total'] ?? 0}';
              final rawTanggal = data['tanggal'];
              final tanggal = rawTanggal is Timestamp
                  ? dateFormat.format(rawTanggal.toDate())
                  : rawTanggal.toString();

              return [nama, jumlah, total, tanggal];
            }).toList(),
          ),
        ],
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }
}