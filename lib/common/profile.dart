import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class Profile {
  static const DefaultFileName = 'default-profile.json';
  static Profile _shared;

  File _file;
  Map<String, dynamic> _values = {};

  static Future<Profile> shared() async {
    if (_shared == null) {
      _shared = Profile();
      await _shared._load(DefaultFileName);
    }
    return _shared;
  }

  operator [](String key) => _values[key];

  operator []=(String key, dynamic value) => _values[key] = value;

  Future<bool> commit() async {
    _file.create(recursive: true);
    try {
      final contents = jsonEncode(_values);
      await _file.writeAsString(contents);
    } catch (error) {
      print('Error: $error');
      return false;
    }
    return true;
  }

  Future<bool> _load(String fileName) async {
    final docDir = await getApplicationDocumentsDirectory();
    _file = File('$docDir/$fileName');
    try {
      final contents = await _file.readAsString();
      _values = jsonDecode(contents);
    } catch (error) {
      print('Error: $error');
      return false;
    }
    return true;
  }
}
