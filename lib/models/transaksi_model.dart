import 'package:cloud_firestore/cloud_firestore.dart';

class TransaksiModel {
  final String id;
  final String namaBarang;
  final int jumlah;
  final double totalHarga;
  final DateTime tanggal;

  TransaksiModel({
    required this.id,
    required this.namaBarang,
    required this.jumlah,
    required this.totalHarga,
    required this.tanggal,
  });

  factory TransaksiModel.fromFirestore(Map<String, dynamic> data, String id) {
    return TransaksiModel(
      id: id,
      namaBarang: data['namaBarang'] ?? '',
      jumlah: data['jumlah'] ?? 0,
      totalHarga: (data['total'] ?? 0).toDouble(),
      tanggal: (data['tanggal'] as Timestamp).toDate(),
    );
  }
}