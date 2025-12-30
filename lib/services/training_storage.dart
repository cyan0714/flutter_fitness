import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/training_record.dart';

class TrainingStorage {
  static const String _key = 'training_records';

  // 保存训练记录
  static Future<void> saveRecord(TrainingRecord record) async {
    final prefs = await SharedPreferences.getInstance();
    final records = await getRecords();
    records.add(record);
    
    final jsonList = records.map((r) => r.toJson()).toList();
    await prefs.setString(_key, jsonEncode(jsonList));
  }

  // 获取所有训练记录
  static Future<List<TrainingRecord>> getRecords() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    
    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }

    try {
      final jsonList = jsonDecode(jsonString) as List;
      return jsonList
          .map((json) => TrainingRecord.fromJson(json as Map<String, dynamic>))
          .toList()
        ..sort((a, b) => b.dateTime.compareTo(a.dateTime)); // 按时间倒序排列
    } catch (e) {
      return [];
    }
  }

  // 删除训练记录
  static Future<void> deleteRecord(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final records = await getRecords();
    records.removeWhere((record) => record.id == id);
    
    final jsonList = records.map((r) => r.toJson()).toList();
    await prefs.setString(_key, jsonEncode(jsonList));
  }

  // 清空所有记录
  static Future<void> clearAllRecords() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}

