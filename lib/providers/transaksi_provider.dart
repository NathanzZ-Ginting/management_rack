import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TransaksiProvider with ChangeNotifier {
  double _totalSaldo = 0;
  double get totalSaldo => _totalSaldo;

  final CollectionReference _transaksiRef =
  FirebaseFirestore.instance.collection('transaksi');

  TransaksiProvider() {
    _ambilSemuaTransaksi(); // ambil data saldo dari histori transaksi
  }

  Future<void> _ambilSemuaTransaksi() async {
    final snapshot = await _transaksiRef.get();
    double total = 0;
    for (var doc in snapshot.docs) {
      // adaptasi field apa pun yang tersedia
      final double nilai = (doc['total'] ?? doc['totalHarga'] ?? 0).toDouble();
      total += nilai;
    }
    _totalSaldo = total;
    notifyListeners();
  }

  // Hapus semua transaksi (opsional)
  Future<void> resetTransaksi() async {
    final snapshot = await _transaksiRef.get();
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
    _totalSaldo = 0;
    notifyListeners();
  }
}