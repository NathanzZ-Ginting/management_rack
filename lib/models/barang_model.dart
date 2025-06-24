class BarangModel {
  final String id;
  final String nama;
  final String kategori;
  final double harga;
  final int stok;
  final String gambar;
  final double rating;

  BarangModel({
    required this.id,
    required this.nama,
    required this.kategori,
    required this.harga,
    required this.stok,
    this.gambar = '',
    this.rating = 4.0,
  });
}