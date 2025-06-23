import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/barang_provider.dart';
import '../services/log_service.dart';
import '../services/pdf_service.dart';
import '../models/log_model.dart';
import 'package:intl/intl.dart';



class RiwayatScreen extends StatefulWidget {
  const RiwayatScreen({super.key});

  @override
  State<RiwayatScreen> createState() => _RiwayatScreenState();
}

class _RiwayatScreenState extends State<RiwayatScreen> {
  List<LogModel> logList = [];

  @override
  void initState() {
    super.initState();
    _loadLog();
  }

  Future<void> _loadLog() async {
    final logs = await LogService.ambilGlobalLog();
    setState(() {
      logList = logs.reversed.toList(); // urutan terbaru di atas
    });
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy – HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Transaksi'),
        actions: [
          IconButton(
            onPressed: () async {
              await PdfService.generateAndPrintPDF();
            },
            icon: const Icon(Icons.picture_as_pdf),
            tooltip: 'Export ke PDF',
          ),
          IconButton(
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Konfirmasi'),
                  content: const Text('Yakin ingin menghapus semua riwayat transaksi?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Batal'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Hapus'),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                await LogService.hapusGlobalLog();
                _loadLog();
              }
            },
            icon: const Icon(Icons.delete_forever),
            tooltip: 'Hapus Semua',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: logList.isEmpty
            ? const Center(child: Text('Belum ada riwayat transaksi'))
            : ListView.builder(
          itemCount: logList.length,
          itemBuilder: (_, index) {
            final log = logList[index];
            return Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Column(
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
                        dateFormat.format(log.waktu),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    log.aksi,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}