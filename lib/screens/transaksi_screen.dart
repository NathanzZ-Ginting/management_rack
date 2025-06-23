import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/barang_model.dart';
import '../providers/barang_provider.dart';
import '../services/log_service.dart';

class TransaksiScreen extends StatefulWidget {
  const TransaksiScreen({super.key});

  @override
  State<TransaksiScreen> createState() => _TransaksiScreenState();
}

class _TransaksiScreenState extends State<TransaksiScreen> {
  BarangModel? barangDipilih;
  final _jumlahController = TextEditingController();

  @override
  void dispose() {
    _jumlahController.dispose();
    super.dispose();
  }

  void _prosesTransaksi() {
    if (barangDipilih == null || _jumlahController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih barang dan masukkan jumlah')),
      );
      return;
    }

    final jumlah = int.tryParse(_jumlahController.text);
    if (jumlah == null || jumlah <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Jumlah tidak valid')),
      );
      return;
    }

    if (jumlah > barangDipilih!.stok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Stok tidak mencukupi')),
      );
      return;
    }

    // Kurangi stok
    final provider = Provider.of<BarangProvider>(context, listen: false);
    provider.updateStok(barangDipilih!.id, barangDipilih!.stok - jumlah);

    // Tambahkan ke log
    LogService.tambahGlobalLog(
      'Terjual: ${barangDipilih!.nama} sebanyak $jumlah pcs',
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final barangList = Provider.of<BarangProvider>(context).semuaBarang;

    return Scaffold(
      appBar: AppBar(title: const Text('Transaksi Terjual')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<BarangModel>(
              value: barangDipilih,
              decoration: const InputDecoration(labelText: 'Pilih Barang'),
              items: barangList.map((barang) {
                return DropdownMenuItem(
                  value: barang,
                  child: Text('${barang.nama} (stok: ${barang.stok})'),
                );
              }).toList(),
              onChanged: (val) => setState(() => barangDipilih = val),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _jumlahController,
              decoration: const InputDecoration(labelText: 'Jumlah Terjual'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.check),
              label: const Text('Simpan Transaksi'),
              onPressed: _prosesTransaksi,
            ),
          ],
        ),
      ),
    );
  }
}