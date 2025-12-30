import 'package:flutter/material.dart';
import '../widgets/equipment_card.dart';

class LegsPage extends StatefulWidget {
  const LegsPage({super.key});

  @override
  State<LegsPage> createState() => _LegsPageState();
}

class _LegsPageState extends State<LegsPage> {
  // 器械列表
  final List<Map<String, String>> _equipmentList = const [
    {'name': 'Leg Press (Hack)', 'chinese': '倒蹬机'},
    {'name': 'Leg Curl', 'chinese': '腘绳肌'},
    {'name': 'Leg Press', 'chinese': '腿推机'},
    {'name': 'Hack Squat', 'chinese': '哈克深蹲'},
    {'name': 'Hip Abductor', 'chinese': '髋外展机'},
  ];

  // 图片列表（按器械顺序对应）
  final List<String> _imageList = const [
    'assets/images/leg/倒蹬机.jpeg',
    'assets/images/leg/腘绳肌.jpg',
    'assets/images/leg/腿推机.jpg',
    'assets/images/leg/哈克深蹲.jpeg',
    'assets/images/leg/髋外展机.jpeg',
  ];

  // 获取图片（根据索引获取对应图片）
  String _getImage(int index) {
    return _imageList[index];
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
