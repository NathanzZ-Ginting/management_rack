import 'package:flutter/material.dart';
import '../models/log_model.dart';
import 'package:intl/intl.dart';

class LogCard extends StatelessWidget {
  final LogModel log;

  const LogCard({super.key, required this.log});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.event_note),
      title: Text(log.aksi),
      subtitle: Text(DateFormat.yMd().add_jm().format(log.waktu)),
    );
  }
}