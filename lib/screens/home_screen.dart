import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'tambah_barang_screen.dart';
import '../providers/barang_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';
import '../screens/login_screen.dart';
import '../widgets/barang_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final barangProvider = Provider.of<BarangProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final semuaBarang = barangProvider.semuaBarang;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Barang'),
        actions: [
          // 🌗 Toggle Dark Mode
          Switch(
            value: themeProvider.isDark,
            onChanged: (_) => themeProvider.toggleTheme(),
          ),
          // 🚪 Tombol Logout
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).logout();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 🔍 Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Cari barang...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                barangProvider.updateSearchQuery(value);
              },
            ),
          ),
          // 📦 List Data
          Expanded(
            child: semuaBarang.isEmpty
                ? const Center(child: Text('Barang tidak ditemukan.'))
                : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: semuaBarang.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, index) {
                return BarangCard(barang: semuaBarang[index]);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TambahBarangScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}