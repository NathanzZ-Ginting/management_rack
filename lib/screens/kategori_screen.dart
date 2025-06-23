import 'package:flutter/material.dart';

class KategoriScreen extends StatefulWidget {
  const KategoriScreen({super.key});

  @override
  State<KategoriScreen> createState() => _KategoriScreenState();
}

class _KategoriScreenState extends State<KategoriScreen> {
  final List<String> _kategori = ['Elektronik', 'Alat Tulis'];
  final _controller = TextEditingController();

  void _tambahKategori() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _kategori.add(_controller.text.trim());
      });
      _controller.clear();
    }
  }

  void _hapusKategori(int index) {
    setState(() {
      _kategori.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kategori Barang')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Tambah Kategori',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _tambahKategori,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                itemCount: _kategori.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (_, index) {
                  return ListTile(
                    title: Text(_kategori[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _hapusKategori(index),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}