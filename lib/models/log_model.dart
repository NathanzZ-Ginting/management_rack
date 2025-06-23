class LogModel {
  final String aksi;
  final DateTime waktu;

  LogModel({required this.aksi, required this.waktu});

  Map<String, dynamic> toJson() => {
    'aksi': aksi,
    'waktu': waktu.toIso8601String(),
  };

  factory LogModel.fromJson(Map<String, dynamic> json) => LogModel(
    aksi: json['aksi'],
    waktu: DateTime.parse(json['waktu']),
  );
}