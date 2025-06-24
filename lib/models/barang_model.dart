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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is BarangModel &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;
}