import 'package:flutter/material.dart';
import '../models/barang_model.dart';

class BarangProvider with ChangeNotifier {
  final List<BarangModel> _semuaBarang = [];
  double _saldo = 0;

  List<BarangModel> get semuaBarang => _semuaBarang;
  double get saldo => _saldo;

  void tambahBarang(
      String nama,
      String kategori,
      double harga,
      int stok, {
        String gambar = '',
        double rating = 4.0,
      }) {
    final barangBaru = BarangModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      nama: nama,
      kategori: kategori,
      harga: harga,
      stok: stok,
      gambar: gambar,
      rating: rating,
    );
    _semuaBarang.add(barangBaru);
    notifyListeners();
  }

  void updateStok(String id, int stokBaru) {
    final index = _semuaBarang.indexWhere((b) => b.id == id);
    if (index != -1) {
      final barang = _semuaBarang[index];
      _semuaBarang[index] = BarangModel(
        id: barang.id,
        nama: barang.nama,
        kategori: barang.kategori,
        harga: barang.harga,
        stok: stokBaru,
        gambar: barang.gambar,
        rating: barang.rating,
      );
      notifyListeners();
    }
  }

  void tambahTransaksi(String id, int jumlahTerjual) {
    final index = _semuaBarang.indexWhere((b) => b.id == id);
    if (index != -1) {
      final barang = _semuaBarang[index];
      final hargaTotal = barang.harga * jumlahTerjual;

      _semuaBarang[index] = BarangModel(
        id: barang.id,
        nama: barang.nama,
        kategori: barang.kategori,
        harga: barang.harga,
        stok: barang.stok - jumlahTerjual,
        gambar: barang.gambar,
        rating: barang.rating,
      );

      _saldo += hargaTotal;
      notifyListeners();
    }
  }

  void hapusBarang(String id) {
    _semuaBarang.removeWhere((barang) => barang.id == id);
    notifyListeners();
  }
}