class TrainingRecord {
  final String id;
  final String equipmentName;
  final String equipmentChinese;
  final int sets;
  final int reps;
  final double weight;
  final String unit;
  final DateTime dateTime;

  TrainingRecord({
    required this.id,
    required this.equipmentName,
    required this.equipmentChinese,
    required this.sets,
    required this.reps,
    required this.weight,
    required this.unit,
    required this.dateTime,
  });

  // 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'equipmentName': equipmentName,
      'equipmentChinese': equipmentChinese,
      'sets': sets,
      'reps': reps,
      'weight': weight,
      'unit': unit,
      'dateTime': dateTime.toIso8601String(),
    };
  }

  // 从JSON创建
  factory TrainingRecord.fromJson(Map<String, dynamic> json) {
    return TrainingRecord(
      id: json['id'] as String,
      equipmentName: json['equipmentName'] as String,
      equipmentChinese: json['equipmentChinese'] as String,
      sets: json['sets'] as int,
      reps: json['reps'] as int,
      weight: (json['weight'] as num).toDouble(),
      unit: json['unit'] as String,
      dateTime: DateTime.parse(json['dateTime'] as String),
    );
  }
}

