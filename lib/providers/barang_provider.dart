import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/barang_model.dart';

class BarangProvider with ChangeNotifier {
  final List<BarangModel> _barang = [];

  String _searchQuery = '';

  // Getter untuk semua barang, dengan search filter
  List<BarangModel> get semuaBarang {
    if (_searchQuery.isEmpty) {
      return _barang;
    } else {
      return _barang
          .where((b) => b.nama.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
  }

  // Update pencarian
  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // Tambah barang baru
  void tambahBarang(String nama, String kategori, double harga, int stok) {
    final barangBaru = BarangModel(
      id: const Uuid().v4(),
      nama: nama,
      kategori: kategori,
      harga: harga,
      stok: stok,
    );
    _barang.add(barangBaru);
    notifyListeners();
  }

  // Update barang secara keseluruhan
  void updateBarang(BarangModel updated) {
    final index = _barang.indexWhere((b) => b.id == updated.id);
    if (index != -1) {
      _barang[index] = updated;
      notifyListeners();
    }
  }

  // Hapus barang
  void hapusBarang(String id) {
    _barang.removeWhere((b) => b.id == id);
    notifyListeners();
  }

  // Kurangi stok
  void kurangiStok(String id, int jumlah) {
    final index = _barang.indexWhere((b) => b.id == id);
    if (index != -1 && _barang[index].stok >= jumlah) {
      _barang[index].stok -= jumlah;
      notifyListeners();
    }
  }

  // ✅ Update harga spesifik
  void updateHarga(String id, double hargaBaru) {
    final index = _barang.indexWhere((b) => b.id == id);
    if (index != -1) {
      _barang[index].harga = hargaBaru;
      notifyListeners();
    }
  }

  // ✅ Update stok spesifik
  void updateStok(String id, int stokBaru) {
    final index = _barang.indexWhere((b) => b.id == id);
    if (index != -1) {
      _barang[index].stok = stokBaru;
      notifyListeners();
    }
  }
}