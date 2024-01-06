import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';

import 'excerpt.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.upload_file),
            title: Text('Export Data'),
            onTap: () => _exportData(context),
          ),
          ListTile(
            leading: Icon(Icons.download_rounded),
            title: Text('Import Data'),
            onTap: () => _importData(context),
          ),
        ],
      ),
    );
  }


  Future<void> _exportData(BuildContext context) async {
    try {
      final jsonString = await exportToJson();
      final directory = await FilePicker.platform.getDirectoryPath();
      if (directory != null) {
        // Format the current date and time
        String formattedDateTime = DateFormat('ddMMyyyy_HHmmss').format(DateTime.now());

        // Create the file name with the app title, date, and time
        final fileName = 'Excerpts_$formattedDateTime.json';
        final filePath = '$directory/$fileName';

        final file = File(filePath);
        await file.writeAsString(jsonString);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data exported to $filePath')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error exporting data: $e')),
      );
    }
  }

  Future<void> _importData(BuildContext context) async {
    try {
      final params = OpenFileDialogParams(
        dialogType: OpenFileDialogType.document,
        sourceType: SourceType.photoLibrary,
        allowedUtiTypes: ['application/json'],
      );
      final filePath = await FlutterFileDialog.pickFile(params: params);
      if (filePath != null) {
        final file = File(filePath);
        final jsonString = await file.readAsString();
        await importFromJson(jsonString);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data imported successfully')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error importing data: $e')),
      );
      print(e);
    }
  }

  // Export to JSON
  Future<String> exportToJson() async {
    final box = Hive.box<Excerpt>('excerpts');
    List<Map<String, dynamic>> jsonData = box.values.map((item) => item.toJson()).toList();
    return jsonEncode(jsonData);
  }

// Import from JSON
  Future<void> importFromJson(String jsonString) async {
    final box = Hive.box<Excerpt>('excerpts');
    List<dynamic> jsonData = jsonDecode(jsonString);
    List<Excerpt> excerpts = jsonData.map((item) => Excerpt.fromJson(item)).toList();
    for (var excerpt in excerpts) {
      await box.add(excerpt);
    }
  }
}
