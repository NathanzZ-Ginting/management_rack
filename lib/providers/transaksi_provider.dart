import 'package:flutter/material.dart';
import '../models/barang_model.dart';

class TransaksiModel {
  final BarangModel barang;
  final int jumlah;

  TransaksiModel({required this.barang, required this.jumlah});
}

class TransaksiProvider with ChangeNotifier {
  final List<TransaksiModel> _semuaTransaksi = [];

  List<TransaksiModel> get semuaTransaksi => _semuaTransaksi;

  void tambahTransaksi(BarangModel barang, int jumlah) {
    _semuaTransaksi.add(TransaksiModel(barang: barang, jumlah: jumlah));
    notifyListeners();
  }

  int get totalTerjual =>
      _semuaTransaksi.fold(0, (sum, t) => sum + t.jumlah);

  double get totalSaldo =>
      _semuaTransaksi.fold(0.0, (sum, t) => sum + (t.barang.harga * t.jumlah));
}