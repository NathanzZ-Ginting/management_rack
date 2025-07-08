import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/transaksi_riwayat_provider.dart';

class RiwayatScreen extends StatefulWidget {
  const RiwayatScreen({super.key});

  @override
  State<RiwayatScreen> createState() => _RiwayatScreenState();
}

class _RiwayatScreenState extends State<RiwayatScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<TransaksiRiwayatProvider>(context, listen: false).ambilRiwayat();
  }

  @override
  Widget build(BuildContext context) {
    final riwayat = Provider.of<TransaksiRiwayatProvider>(context).riwayat;
    final dateFormat = DateFormat('dd MMM yyyy – HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Transaksi (Firestore)'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: riwayat.isEmpty
            ? const Center(child: Text('Belum ada transaksi'))
            : ListView.builder(
          itemCount: riwayat.length,
          itemBuilder: (context, index) {
            final data = riwayat[index];
            final tanggal = DateTime.tryParse(data['tanggal'] ?? '') ?? DateTime.now();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Text(
                      dateFormat.format(tanggal),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${data['namaBarang']} - ${data['jumlah']} pcs, Total: Rp${data['totalHarga'].toString()}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 16),
              ],
            );
          },
        ),
      ),
    );
  }
}