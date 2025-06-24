import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../providers/barang_provider.dart';

class TambahBarangScreen extends StatefulWidget {
  const TambahBarangScreen({super.key});

  @override
  State<TambahBarangScreen> createState() => _TambahBarangScreenState();
}

class _TambahBarangScreenState extends State<TambahBarangScreen> {
  final _formKey = GlobalKey<FormState>();

  final _namaController = TextEditingController();
  final _kategoriController = TextEditingController();
  final _hargaController = TextEditingController();
  final _stokController = TextEditingController();
  final _ratingController = TextEditingController();

  File? _gambarFile;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _gambarFile = File(pickedFile.path);
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final nama = _namaController.text;
      final kategori = _kategoriController.text;
      final harga = double.tryParse(_hargaController.text) ?? 0;
      final stok = int.tryParse(_stokController.text) ?? 0;
      final rating = double.tryParse(_ratingController.text) ?? 4.0;
      final gambarPath = _gambarFile?.path ?? '';

      Provider.of<BarangProvider>(context, listen: false).tambahBarang(
        nama,
        kategori,
        harga,
        stok,
        gambar: gambarPath,
        rating: rating,
      );

      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _kategoriController.dispose();
    _hargaController.dispose();
    _stokController.dispose();
    _ratingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Barang')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(labelText: 'Nama Barang'),
                validator: (value) =>
                value!.isEmpty ? 'Nama tidak boleh kosong' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _kategoriController,
                decoration: const InputDecoration(labelText: 'Kategori'),
                validator: (value) =>
                value!.isEmpty ? 'Kategori tidak boleh kosong' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _hargaController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Harga'),
                validator: (value) =>
                value!.isEmpty ? 'Harga tidak boleh kosong' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _stokController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Stok'),
                validator: (value) =>
                value!.isEmpty ? 'Stok tidak boleh kosong' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _ratingController,
                keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
                decoration:
                const InputDecoration(labelText: 'Rating (1.0 - 5.0)'),
                validator: (value) {
                  final val = double.tryParse(value ?? '');
                  if (val == null || val < 1.0 || val > 5.0) {
                    return 'Masukkan rating antara 1.0 - 5.0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Gambar
              Column(
                children: [
                  _gambarFile == null
                      ? const Text('Belum ada gambar dipilih')
                      : Image.file(_gambarFile!, height: 150),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.upload),
                    label: const Text('Pilih Gambar'),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: _submit,
                child: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}