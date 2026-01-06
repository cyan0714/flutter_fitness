import 'package:flutter/material.dart';
import '../models/training_record.dart';
import '../services/training_storage.dart';

class TrainingDialogHelper {
  // 显示训练输入对话框
  static void showTrainingDialog(
    BuildContext context,
    Map<String, String> equipment,
  ) {
    final TextEditingController setsController = TextEditingController();
    final TextEditingController repsController = TextEditingController();
    final TextEditingController weightController = TextEditingController();
    String selectedUnit = 'kg';
    String? errorMessage;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(equipment['chinese'] ?? equipment['name']!),
              content: SingleChildScrollView(
                child: Column(
                  // 设置Column的mainAxisSize为min，使对话框内容只占用必要的空间，而不是填满整个可用高度
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 错误提示
                    if (errorMessage != null) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red[300]!),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Colors.red[700],
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                errorMessage!,
                                style: TextStyle(
                                  color: Colors.red[700],
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
                      onChanged: (_) {
                        if (errorMessage != null) {
                          setState(() {
                            errorMessage = null;
                          });
                        }
                      },
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
                      onChanged: (_) {
                        if (errorMessage != null) {
                          setState(() {
                            errorMessage = null;
                          });
                        }
                      },
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
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                              signed: false,
                            ),
                            onChanged: (_) {
                              if (errorMessage != null) {
                                setState(() {
                                  errorMessage = null;
                                });
                              }
                            },
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
                    // 关闭当前对话框（取消按钮被点击时）
                    // 调用pop方法用于关闭当前显示的对话框（弹窗）并返回到上一个界面
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
                      setState(() {
                        errorMessage = '请填写所有字段';
                      });
                      return;
                    }

                    // 获取输入值
                    final sets = int.tryParse(setsController.text);
                    final reps = int.tryParse(repsController.text);
                    final weight = double.tryParse(weightController.text);

                    if (sets == null || reps == null || weight == null) {
                      setState(() {
                        errorMessage = '请输入有效的数字';
                      });
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

                    TrainingStorage.saveRecord(record)
                        .then((_) {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '已记录：${equipment['chinese']} - $sets组 × $reps次 × ${weight}${selectedUnit}',
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        })
                        .catchError((error) {
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
}
