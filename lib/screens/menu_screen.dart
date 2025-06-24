import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'riwayat_screen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),

            // Header Tengah Atas
            Center(
              child: Text(
                'Home',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ),

            const SizedBox(height: 50),

            // Tombol Navigasi
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Tombol Kelola Barang (biru)
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const HomeScreen()),
                        );
                      },
                      icon: const Icon(Icons.inventory),
                      label: const Text('Kelola Barang'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: isDark ? Colors.blue.shade500 : Colors.blue.shade700,
                        backgroundColor: Colors.transparent,
                        side: BorderSide(
                          color: isDark ? Colors.blue.shade500 : Colors.blue.shade700,
                        ),
                        shadowColor: Colors.transparent,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textStyle: const TextStyle(fontWeight: FontWeight.w600),
                      ).copyWith(
                        overlayColor: MaterialStateProperty.all(
                          isDark
                              ? Colors.blue.shade500.withOpacity(0.1)
                              : Colors.blue.shade100,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Tombol Riwayat Transaksi (merah)
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const RiwayatScreen()),
                        );
                      },
                      icon: const Icon(Icons.history),
                      label: const Text('Riwayat Transaksi'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: isDark ? Colors.red.shade400 : Colors.red.shade700,
                        backgroundColor: Colors.transparent,
                        side: BorderSide(
                          color: isDark ? Colors.red.shade400 : Colors.red.shade700,
                        ),
                        shadowColor: Colors.transparent,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textStyle: const TextStyle(fontWeight: FontWeight.w600),
                      ).copyWith(
                        overlayColor: MaterialStateProperty.all(
                          isDark
                              ? Colors.red.shade400.withOpacity(0.1)
                              : Colors.red.shade100,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}