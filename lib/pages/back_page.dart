import 'package:flutter/material.dart';
import '../widgets/equipment_card.dart';

class BackPage extends StatefulWidget {
  const BackPage({super.key});

  @override
  State<BackPage> createState() => _BackPageState();
}

class _BackPageState extends State<BackPage> {
  // 器械列表
  final List<Map<String, String>> _equipmentList = const [
    {'name': 'Assisted Pull-up', 'chinese': '助力引体向上'},
    {'name': 'Seated Row', 'chinese': '坐姿划船'},
    {'name': 'Lat Pulldown', 'chinese': '高位下拉'},
    {'name': 'Lat Pulldown Machine', 'chinese': '高位下拉固定器械'},
  ];

  // 图片列表（按器械顺序对应）
  final List<String> _imageList = const [
    'assets/images/back/助力引体向上.jpeg',
    'assets/images/back/坐姿划船.jpg',
    'assets/images/back/高位下拉.jpeg',
    'assets/images/back/高位下拉固定器械.jpeg',
  ];

  // 获取图片（根据索引获取对应图片）
  String _getImage(int index) {
    return _imageList[index];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('背部训练'),
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

