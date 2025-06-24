import 'dart:io';
import 'package:flutter/material.dart';
import '../models/barang_model.dart';

class BarangCard extends StatelessWidget {
  final BarangModel barang;

  const BarangCard({super.key, required this.barang});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    int fullStars = barang.rating.floor();
    bool hasHalfStar = (barang.rating - fullStars) >= 0.5;

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
          // Gambar produk (dari file)
          barang.gambar.isNotEmpty && File(barang.gambar).existsSync()
              ? ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.file(
              File(barang.gambar),
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          )
              : Container(
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[800] : Colors.grey[100],
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.inventory_2,
              size: 64,
              color: Colors.blue,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            barang.nama,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black87,
            ),
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

          // Rating dinamis
          Row(
            children: [
              Row(
                children: List.generate(5, (index) {
                  if (index < fullStars) {
                    return const Icon(Icons.star, color: Colors.amber, size: 18);
                  } else if (index == fullStars && hasHalfStar) {
                    return const Icon(Icons.star_half, color: Colors.amber, size: 18);
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
}