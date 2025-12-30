import 'package:flutter/material.dart';
import 'dart:math';
import '../models/training_record.dart';
import '../services/training_storage.dart';

class LegsPage extends StatefulWidget {
  const LegsPage({super.key});

  @override
  State<LegsPage> createState() => _LegsPageState();
}

class _LegsPageState extends State<LegsPage> {
  // 器械列表
  final List<Map<String, String>> _equipmentList = const [
    {'name': 'Leg Extension', 'chinese': '腿屈伸'},
    {'name': 'Inner Impress', 'chinese': '内收肌训练'},
    {'name': 'Leg Press', 'chinese': '腿举'},
    {'name': 'Hammer Strength', 'chinese': '哈默力量'},
  ];

  // 图片列表
  final List<String> _imageList = const [
    'assets/images/legpress.jpg',
    'assets/images/legpress2.jpg',
    'assets/images/paobuji.jpg',
  ];

  // 随机获取图片
  String _getRandomImage(int index) {
    final random = Random(index);
    return _imageList[random.nextInt(_imageList.length)];
  }

  // 显示训练输入对话框
  void _showTrainingDialog(BuildContext context, Map<String, String> equipment) {
    final TextEditingController setsController = TextEditingController();
    final TextEditingController repsController = TextEditingController();
    final TextEditingController weightController = TextEditingController();
    String selectedUnit = 'kg';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(equipment['chinese'] ?? equipment['name']!),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 组数输入
                    TextField(
                      controller: setsController,
                      decoration: const InputDecoration(
                        labelText: '组数',
                        hintText: '请输入组数',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.format_list_numbered),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    // 每组次数输入
                    TextField(
                      controller: repsController,
                      decoration: const InputDecoration(
                        labelText: '每组次数',
                        hintText: '请输入每组次数',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.repeat),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    // 重量输入和单位选择
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: weightController,
                            decoration: const InputDecoration(
                              labelText: '重量',
                              hintText: '请输入重量',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.fitness_center),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: DropdownButton<String>(
                              value: selectedUnit,
                              isExpanded: true,
                              underline: const SizedBox(),
                              items: const [
                                DropdownMenuItem(
                                  value: 'kg',
                                  child: Center(child: Text('kg')),
                                ),
                                DropdownMenuItem(
                                  value: 'lbs',
                                  child: Center(child: Text('lbs')),
                                ),
                              ],
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    selectedUnit = newValue;
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('取消'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // 验证输入
                    if (setsController.text.isEmpty ||
                        repsController.text.isEmpty ||
                        weightController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('请填写所有字段'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      return;
                    }

                    // 获取输入值
                    final sets = int.tryParse(setsController.text);
                    final reps = int.tryParse(repsController.text);
                    final weight = double.tryParse(weightController.text);

                    if (sets == null || reps == null || weight == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('请输入有效的数字'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      return;
                    }

                    // 保存数据到本地
                    final record = TrainingRecord(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      equipmentName: equipment['name']!,
                      equipmentChinese: equipment['chinese']!,
                      sets: sets,
                      reps: reps,
                      weight: weight,
                      unit: selectedUnit,
                      dateTime: DateTime.now(),
                    );

                    TrainingStorage.saveRecord(record).then((_) {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '已记录：${equipment['chinese']} - $sets组 × $reps次 × ${weight}${selectedUnit}',
                          ),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }).catchError((error) {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('保存失败：$error'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    });
                  },
                  child: const Text('确认'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('腿部训练'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 每行2个
            crossAxisSpacing: 16.0, // 水平间距
            mainAxisSpacing: 16.0, // 垂直间距
            childAspectRatio: 1.0, // 正方形
          ),
          itemCount: _equipmentList.length,
          itemBuilder: (context, index) {
            final equipment = _equipmentList[index];
            final imagePath = _getRandomImage(index);
            
            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                onTap: () {
                  _showTrainingDialog(context, equipment);
                },
                borderRadius: BorderRadius.circular(12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                        child: Image.asset(
                          imagePath,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[300],
                              child: const Icon(
                                Icons.image_not_supported,
                                size: 50,
                                color: Colors.grey,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 6.0,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(12),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 2),
                          Text(
                            equipment['name']!,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
