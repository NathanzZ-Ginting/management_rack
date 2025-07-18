import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TransaksiRiwayatProvider with ChangeNotifier {
  List<Map<String, dynamic>> _riwayat = [];

  List<Map<String, dynamic>> get riwayat => _riwayat;

  Future<void> ambilRiwayat() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('transaksi')
        .orderBy('tanggal', descending: true)
        .get();

    _riwayat = snapshot.docs.map((doc) => doc.data()).toList();
    notifyListeners();
  }
}