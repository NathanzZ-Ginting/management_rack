import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/barang_provider.dart';
import 'home_screen.dart';
import 'riwayat_screen.dart';
import 'login_screen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  void _konfirmasiLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF1F2937) // dark:bg-gray-800
            : const Color(0xFFFFF1F1), // bg-red-50
        titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFF991B1B) // dark:border-red-800
                : const Color(0xFFFCA5A5), // border-red-300
          ),
        ),
        title: Row(
          children: [
            const Icon(Icons.warning_rounded, color: Color(0xFFB91C1C), size: 24), // text-red-800
            const SizedBox(width: 8),
            Text(
              'Logout',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFFF87171) // dark:text-red-400
                    : const Color(0xFFB91C1C), // text-red-800
              ),
            ),
          ],
        ),
        content: Text(
          'Yakin ingin logout?',
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFFFCA5A5)
                : const Color(0xFF7F1D1D),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Batal',
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[300]
                    : Colors.grey[800],
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626), // bg-red-600
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).logout();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
              );
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final barangProv = Provider.of<BarangProvider>(context);
    final totalSaldo = barangProv.saldo;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Navigation',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          themeProvider.isDarkMode
                              ? Icons.light_mode
                              : Icons.dark_mode,
                        ),
                        onPressed: () => themeProvider.toggleTheme(),
                      ),
                      IconButton(
                        icon: const Icon(Icons.logout),
                        onPressed: () => _konfirmasiLogout(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 60),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const HomeScreen()),
                        );
                      },
                      icon: const Icon(Icons.inventory),
                      label: const Text('Kelola Barang'),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 60),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const RiwayatScreen()),
                        );
                      },
                      icon: const Icon(Icons.history),
                      label: const Text('Riwayat Transaksi'),
                    ),
                    const SizedBox(height: 40),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Saldo Saat Ini',
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Rp ${totalSaldo.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: Colors.redAccent,
                      ),
                      onPressed: () async {
                        final konfirmasi = await showDialog<bool>(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Reset Saldo'),
                            content: const Text(
                              'Semua transaksi akan dihapus dan saldo akan diset ke 0. Yakin?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, false),
                                child: const Text('Batal'),
                              ),
                              ElevatedButton(
                                onPressed: () =>
                                    Navigator.pop(context, true),
                                child: const Text('Reset'),
                              ),
                            ],
                          ),
                        );

                        if (konfirmasi == true) {
                          await barangProv.resetSaldo();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  '✅ Saldo & Transaksi berhasil direset'),
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reset Saldo'),
                    )
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