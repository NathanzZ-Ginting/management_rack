import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/barang_model.dart';
import '../providers/barang_provider.dart';

class BarangCard extends StatelessWidget {
  final BarangModel barang;
  const BarangCard({super.key, required this.barang});

  void _editHarga(BuildContext context) {
    final controller = TextEditingController(text: barang.harga.toString());

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Harga'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Harga Baru'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              final hargaBaru = double.tryParse(controller.text);
              if (hargaBaru != null) {
                Provider.of<BarangProvider>(context, listen: false)
                    .updateHarga(barang.id, hargaBaru);
              }
              Navigator.pop(context);
            },
            child: const Text('Simpan'),
          )
        ],
      ),
    );
  }

  void _editStok(BuildContext context) {
    final controller = TextEditingController(text: barang.stok.toString());

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Stok'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Stok Baru'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              final stokBaru = int.tryParse(controller.text);
              if (stokBaru != null) {
                Provider.of<BarangProvider>(context, listen: false)
                    .updateStok(barang.id, stokBaru);
              }
              Navigator.pop(context);
            },
            child: const Text('Simpan'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shadowColor: Colors.grey.shade300,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(barang.nama, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Kategori: ${barang.kategori}'),
            Text('Stok: ${barang.stok}'),
            Text('Harga: Rp ${barang.harga.toStringAsFixed(0)}'),
          ],
        ),
        trailing: PopupMenuButton(
          onSelected: (value) {
            if (value == 'harga') {
              _editHarga(context);
            } else if (value == 'stok') {
              _editStok(context);
            } else if (value == 'hapus') {
              Provider.of<BarangProvider>(context, listen: false)
                  .hapusBarang(barang.id);
            }
          },
          itemBuilder: (_) => [
            const PopupMenuItem(value: 'harga', child: Text('Edit Harga')),
            const PopupMenuItem(value: 'stok', child: Text('Edit Stok')),
            const PopupMenuItem(value: 'hapus', child: Text('Hapus Barang')),
          ],
        ),
      ),
    );
  }
}