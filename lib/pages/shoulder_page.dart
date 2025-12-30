import 'package:flutter/material.dart';
import '../widgets/equipment_card.dart';

class ShoulderPage extends StatefulWidget {
  const ShoulderPage({super.key});

  @override
  State<ShoulderPage> createState() => _ShoulderPageState();
}

class _ShoulderPageState extends State<ShoulderPage> {
  // 器械列表
  final List<Map<String, String>> _equipmentList = const [
    {'name': 'Lateral Raise(fixed)', 'chinese': '侧平举(固定器械)'},
    {'name': 'Forward Raise', 'chinese': '前平举'},
    {'name': 'Reverse flying bird', 'chinese': '反向飞鸟'},
    {'name': 'Lateral Raise', 'chinese': '哑铃侧平举'},
    {'name': 'Sitting shoulder push', 'chinese': '坐姿推肩'},
  ];

  // 图片列表（按器械顺序对应）
  final List<String> _imageList = const [
    'assets/images/shoulder/侧平举(固定器械).jpg',
    'assets/images/shoulder/前平举.png',
    'assets/images/shoulder/反向飞鸟.jpg',
    'assets/images/shoulder/哑铃侧平举.png',
    'assets/images/shoulder/坐姿推肩.png',
  ];

  // 获取图片（根据索引获取对应图片）
  String _getImage(int index) {
    return _imageList[index];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('肩部训练'),
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
            final imagePath = _getImage(index);
            
            return EquipmentCard(
              equipment: equipment,
              imagePath: imagePath,
            );
          },
        ),
      ),
    );
  }
}

