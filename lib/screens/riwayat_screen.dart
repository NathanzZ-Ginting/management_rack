import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class RiwayatScreen extends StatelessWidget {
  const RiwayatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy – HH:mm');
    final transaksiRef = FirebaseFirestore.instance.collection('transaksi').orderBy('tanggal', descending: true);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Transaksi'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: transaksiRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Belum ada transaksi'));
          }

          final transaksiList = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: transaksiList.length,
            itemBuilder: (context, index) {
              final data = transaksiList[index].data() as Map<String, dynamic>;

              final nama = data['namaBarang'] ?? 'Barang';
              final jumlah = data['jumlah'] ?? 0;
              final total = data['total'] ?? 0;
              final rawTanggal = data['tanggal'];
              final tanggal = rawTanggal is Timestamp
                  ? rawTanggal.toDate()
                  : DateTime.tryParse(rawTanggal.toString()) ?? DateTime.now();

              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nama,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text('Jumlah: $jumlah'),
                    Text('Total: Rp $total'),
                    Text(
                      dateFormat.format(tanggal),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const Divider(),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}