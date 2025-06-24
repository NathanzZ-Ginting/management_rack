import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/barang_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/barang_card.dart';
import '../widgets/breadcrumb_widget.dart';
import 'tambah_barang_screen.dart';
import 'transaksi_screen.dart';
import 'login_screen.dart';

// bagian import tetap
// ...
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _konfirmasiLogout(BuildContext context) {
    // tidak diubah
  }

  @override
  Widget build(BuildContext context) {
    final barangProvider = Provider.of<BarangProvider>(context);
    final semuaBarang = barangProvider.semuaBarang;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDark ? Colors.grey[900] : Colors.blue,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        title: const Breadcrumb(items: ['Home', 'Data Barang']),
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: Colors.white,
            ),
            onPressed: () => themeProvider.toggleTheme(),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => _konfirmasiLogout(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // 🔍 Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: barangProvider.setSearchQuery,
              decoration: InputDecoration(
                hintText: 'Cari nama atau kategori barang...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: isDark ? Colors.grey[800] : Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // 📦 List Barang
          Expanded(
            child: semuaBarang.isEmpty
                ? const Center(child: Text('Belum ada barang.'))
                : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: semuaBarang.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, index) {
                return BarangCard(barang: semuaBarang[index]);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'terjual',
            backgroundColor: Colors.red,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TransaksiScreen()),
              );
            },
            child: const Icon(Icons.shopping_cart),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            heroTag: 'tambah',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TambahBarangScreen()),
              );
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}