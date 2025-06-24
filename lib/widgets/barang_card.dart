import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/barang_model.dart';
import '../providers/barang_provider.dart';

class BarangCard extends StatelessWidget {
  final BarangModel barang;

  const BarangCard({super.key, required this.barang});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final barangProvider = Provider.of<BarangProvider>(context, listen: false);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        border: Border.all(
          color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black26 : Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar atau icon
          Container(
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[800] : Colors.grey[100],
              borderRadius: BorderRadius.circular(10),
            ),
            child: barang.gambar.isNotEmpty
                ? ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.file(
                File(barang.gambar),
                fit: BoxFit.cover,
              ),
            )
                : const Icon(
              Icons.inventory_2,
              size: 64,
              color: Colors.blue,
            ),
          ),

          const SizedBox(height: 12),

          // Judul + tombol titik tiga
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  barang.nama,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'stok') {
                    _showEditDialog(
                      context,
                      title: 'Edit Stok',
                      initialValue: barang.stok.toString(),
                      onSave: (val) {
                        final newStok = int.tryParse(val);
                        if (newStok != null) {
                          barangProvider.updateStok(barang.id, newStok);
                        }
                      },
                    );
                  } else if (value == 'harga') {
                    _showEditDialog(
                      context,
                      title: 'Edit Harga',
                      initialValue: barang.harga.toStringAsFixed(0),
                      onSave: (val) {
                        final newHarga = double.tryParse(val);
                        if (newHarga != null) {
                          barangProvider.tambahBarang(
                            barang.nama,
                            barang.kategori,
                            newHarga,
                            barang.stok,
                            gambar: barang.gambar,
                            rating: barang.rating,
                          );
                          barangProvider.hapusBarang(barang.id);
                        }
                      },
                    );
                  } else if (value == 'hapus') {
                    barangProvider.hapusBarang(barang.id);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'stok', child: Text('Edit Stok')),
                  const PopupMenuItem(value: 'harga', child: Text('Edit Harga')),
                  const PopupMenuItem(
                    value: 'hapus',
                    child: Text(
                      'Hapus Barang',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 6),

          Text(
            'Kategori: ${barang.kategori}',
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.grey[300] : Colors.grey[700],
            ),
          ),

          const SizedBox(height: 8),

          // Rating
          Row(
            children: [
              Row(
                children: List.generate(5, (index) {
                  if (index < barang.rating.floor()) {
                    return const Icon(Icons.star, color: Colors.amber, size: 18);
                  } else {
                    return const Icon(Icons.star_border, color: Colors.grey, size: 18);
                  }
                }),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  barang.rating.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Rp ${barang.harga.toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              Text(
                'Stok: ${barang.stok}',
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.grey[300] : Colors.grey[700],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showEditDialog(
      BuildContext context, {
        required String title,
        required String initialValue,
        required Function(String) onSave,
      }) {
    final controller = TextEditingController(text: initialValue);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              onSave(controller.text);
              Navigator.pop(context);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }
}