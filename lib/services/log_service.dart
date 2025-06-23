import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/log_model.dart';

class LogService {
  static Future<File> _getFile(String barangId) async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/log_$barangId.json');
  }

  static Future<void> tambahLog(String barangId, String aksi) async {
    final file = await _getFile(barangId);
    List<LogModel> logs = [];

    if (await file.exists()) {
      final content = await file.readAsString();
      final jsonList = json.decode(content);
      logs = List<LogModel>.from(jsonList.map((e) => LogModel.fromJson(e)));
    }

    logs.add(LogModel(aksi: aksi, waktu: DateTime.now()));
    await file.writeAsString(json.encode(logs.map((e) => e.toJson()).toList()));
  }

  static Future<List<LogModel>> ambilLog(String barangId) async {
    final file = await _getFile(barangId);
    if (!await file.exists()) return [];

    final content = await file.readAsString();
    final jsonList = json.decode(content);
    return List<LogModel>.from(jsonList.map((e) => LogModel.fromJson(e)));
  }

  // ✅ GLOBAL LOG
  static Future<File> _getGlobalLogFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/log_global.json');
  }

  static Future<void> tambahGlobalLog(String aksi) async {
    final file = await _getGlobalLogFile();
    List<LogModel> logs = [];

    if (await file.exists()) {
      final content = await file.readAsString();
      final jsonList = json.decode(content);
      logs = List<LogModel>.from(jsonList.map((e) => LogModel.fromJson(e)));
    }

    logs.add(LogModel(aksi: aksi, waktu: DateTime.now()));
    await file.writeAsString(json.encode(logs.map((e) => e.toJson()).toList()));
  }

  static Future<List<LogModel>> ambilGlobalLog() async {
    final file = await _getGlobalLogFile();
    if (!await file.exists()) return [];

    final content = await file.readAsString();
    final jsonList = json.decode(content);
    return List<LogModel>.from(jsonList.map((e) => LogModel.fromJson(e)));
  }
  static Future<void> hapusGlobalLog() async {
    final file = await _getGlobalLogFile();
    if (await file.exists()) {
      await file.delete();
    }
  }
}