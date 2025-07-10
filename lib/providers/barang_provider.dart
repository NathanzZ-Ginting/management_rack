import 'package:flutter/material.dart';
import '../models/barang_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BarangProvider with ChangeNotifier {
  final List<BarangModel> _semuaBarang = [];
  double _saldo = 0;

  final _barangCollection = FirebaseFirestore.instance.collection('barang');

  List<BarangModel> get semuaBarang => _semuaBarang;
  double get saldo => _saldo;

  BarangProvider() {
    _ambilBarangDariFirestore();
    _ambilSaldoDariFirestore(); // ambil saldo saat init
  }

  void _ambilBarangDariFirestore() {
    _barangCollection.snapshots().listen((snapshot) {
      _semuaBarang.clear();
      for (var doc in snapshot.docs) {
        final data = doc.data();
        _semuaBarang.add(BarangModel(
          id: doc.id,
          nama: data['nama'],
          kategori: data['kategori'],
          harga: data['harga'],
          stok: data['stok'],
          gambar: data['gambar'] ?? '',
          rating: (data['rating'] ?? 4.0).toDouble(),
        ));
      }
      notifyListeners();
    });
  }

  void _ambilSaldoDariFirestore() async {
    final doc =
    await FirebaseFirestore.instance.collection('meta').doc('saldo').get();
    if (doc.exists) {
      _saldo = (doc.data()!['jumlah'] as num).toDouble();
      notifyListeners();
    }
  }

  Future<void> tambahBarang(
      String nama,
      String kategori,
      double harga,
      int stok, {
        String gambar = '',
        double rating = 4.0,
      }) async {
    final barangBaru = {
      'nama': nama,
      'kategori': kategori,
      'harga': harga,
      'stok': stok,
      'gambar': gambar,
      'rating': rating,
    };
    await _barangCollection.add(barangBaru);
  }

  Future<void> updateStok(String id, int stokBaru) async {
    await _barangCollection.doc(id).update({'stok': stokBaru});
  }

  Future<void> tambahTransaksi(String id, int jumlahTerjual) async {
    final doc = await _barangCollection.doc(id).get();
    if (!doc.exists) return;

    final data = doc.data()!;
    final stokSekarang = data['stok'] ?? 0;
    final harga = (data['harga'] ?? 0).toDouble();
    final namaBarang = data['nama'] ?? 'Barang';

    if (stokSekarang < jumlahTerjual) return;

    final totalHarga = harga * jumlahTerjual;

    await _barangCollection.doc(id).update({
      'stok': stokSekarang - jumlahTerjual,
    });

    await FirebaseFirestore.instance.collection('transaksi').add({
      'barangId': id,
      'namaBarang': namaBarang,
      'jumlah': jumlahTerjual,
      'total': totalHarga,
      'harga': harga,
      'tanggal': Timestamp.now(),
    });

    _saldo += totalHarga;
    notifyListeners();

    // Simpan saldo
    await FirebaseFirestore.instance
        .collection('meta')
        .doc('saldo')
        .set({'jumlah': _saldo});
  }

  Future<void> hapusBarang(String id) async {
    await _barangCollection.doc(id).delete();
  }

  Future<void> resetSaldo() async {
    // Hapus semua transaksi
    final snapshot =
    await FirebaseFirestore.instance.collection('transaksi').get();
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }

    // Set saldo jadi 0
    _saldo = 0;
    notifyListeners();

    await FirebaseFirestore.instance
        .collection('meta')
        .doc('saldo')
        .set({'jumlah': 0});
  }
}