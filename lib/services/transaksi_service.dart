import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/transaksi_model.dart';

class TransaksiService {
  static Future<List<TransaksiModel>> ambilSemua() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('transaksi')
        .orderBy('tanggal', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      return TransaksiModel.fromFirestore(doc.data(), doc.id);
    }).toList();
  }
}