import 'package:flutter/material.dart';
import '../models/barang_model.dart';
import '../models/log_model.dart';
import '../services/log_service.dart';
import '../widgets/log_card.dart';

class RiwayatBarangScreen extends StatefulWidget {
  final BarangModel barang;

  const RiwayatBarangScreen({super.key, required this.barang});

  @override
  State<RiwayatBarangScreen> createState() => _RiwayatBarangScreenState();
}

class _RiwayatBarangScreenState extends State<RiwayatBarangScreen> {
  List<LogModel> logs = [];

  @override
  void initState() {
    super.initState();
    _loadLog();
  }

  void _loadLog() async {
    final data = await LogService.ambilLog(widget.barang.id);
    setState(() => logs = data.reversed.toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Riwayat: ${widget.barang.nama}'),
      ),
      body: logs.isEmpty
          ? const Center(child: Text('Belum ada riwayat.'))
          : ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: logs.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (_, i) => LogCard(log: logs[i]),
      ),
    );
  }
}