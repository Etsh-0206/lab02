import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CSS3344 Lab 02',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      home: const Lab02PreviewScreen(),
    );
  }
}

// ===== 学生信息区（从 Lab01 提取成独立组件）=====
class StudentInfoSection extends StatelessWidget {
  const StudentInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/p.jpg'),
            ),
            const SizedBox(height: 20),
            const Text(
              'EDISON TING SIE HON',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Student ID: BCS24090036',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const Divider(height: 32, thickness: 1),
            const Text(
              'Personal Life Goal / Quote:',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text(
              'BECOME A RICH MAN',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontStyle: FontStyle.italic,
                color: Colors.indigo,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===== 图片区：显示 lake.jpg =====
class ImageSection extends StatelessWidget {
  final String imagePath;

  const ImageSection({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imagePath,
      width: double.infinity,
      height: 240,
      fit: BoxFit.cover,
    );
  }
}

// ===== Exercise 2.1: 组件拆分 —— TitleSection =====
class TitleSection extends StatelessWidget {
  final String name;
  final String location;
  final int starCount;

  const TitleSection({
    super.key,
    required this.name,
    required this.location,
    required this.starCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  location,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Icon(Icons.star, color: Colors.red[500]),
          const SizedBox(width: 4),
          Text('$starCount'),
        ],
      ),
    );
  }
}

// 预览页：Exercise 2.2 自适应布局（OrientationBuilder），匹配老师预期的横竖屏效果
class Lab02PreviewScreen extends StatelessWidget {
  const Lab02PreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CSS3344 Mobile App Dev - Lab 02'),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune),
            tooltip: 'Open Pickers',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PickersScreen()),
              );
            },
          ),
        ],
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return orientation == Orientation.portrait
              ? _buildPortraitView()
              : _buildLandscapeView();
        },
      ),
    );
  }

  Widget _buildPortraitView() {
    return ListView(
      children: const [
        StudentInfoSection(),
        TitleSection(
          name: 'Cocora Valley',
          location: 'Salento, Colombia',
          starCount: 41,
        ),
        ImageSection(imagePath: 'assets/images/images.jpeg'),
      ],
    );
  }

  Widget _buildLandscapeView() {
    return Row(
      children: [
        Expanded(
          child: ListView(
            children: const [StudentInfoSection()],
          ),
        ),
        Expanded(
          child: ListView(
            children: const [
              TitleSection(
                name: 'Cocora Valley',
                location: 'Salento,Colombia',
                starCount: 41,
              ),
              ImageSection(imagePath: 'assets/images/images.jpeg'),
            ],
          ),
        ),
      ],
    );
  }
}

// ===== Exercise 2.3: 四种 Picker（Material vs Cupertino）=====
class PickersScreen extends StatefulWidget {
  const PickersScreen({super.key});

  @override
  State<PickersScreen> createState() => _PickersScreenState();
}

class _PickersScreenState extends State<PickersScreen> {
  // 状态：记住用户选中的值
  DateTime _selectedDate = DateTime.now();
  String _selectedRole = 'Student';
  final List<String> _roles = ['Student', 'Developer', 'Designer'];

  // 1. Material Date Picker：弹出日历对话框
  Future<void> _selectMaterialDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  // 2. Cupertino Date Picker：底部弹出滚轮日期选择器
  void _showCupertinoDatePicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 240,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: CupertinoDatePicker(
          mode: CupertinoDatePickerMode.date,
          initialDateTime: DateTime.now(),
          onDateTimeChanged: (DateTime newDate) {
            setState(() => _selectedDate = newDate);
          },
        ),
      ),
    );
  }

  // 4. Cupertino Wheel Picker：底部弹出滚轮选择角色
  void _showCupertinoRolePicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 200,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: CupertinoPicker(
          itemExtent: 32,
          onSelectedItemChanged: (int index) {
            setState(() => _selectedRole = _roles[index]);
          },
          children: _roles
              .map((role) => Center(child: Text(role)))
              .toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pickers - Material vs Cupertino')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Material Date Picker',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: _selectMaterialDate,
            icon: const Icon(Icons.calendar_month),
            label: Text(
              'Selected: ${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}',
            ),
          ),
          const Divider(height: 32),

          const Text(
            'Cupertino Date Picker',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: _showCupertinoDatePicker,
            icon: const Icon(Icons.date_range),
            label: Text(
              'Selected: ${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}',
            ),
          ),
          const Divider(height: 32),

          const Text(
            'Material DropdownButton',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          DropdownButton<String>(
            value: _selectedRole,
            items: _roles.map((String role) {
              return DropdownMenuItem<String>(
                value: role,
                child: Text(role),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() => _selectedRole = newValue);
              }
            },
          ),
          const Divider(height: 32),

          const Text(
            'Cupertino Wheel Picker',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: _showCupertinoRolePicker,
            icon: const Icon(Icons.view_week),
            label: Text('Selected: $_selectedRole'),
          ),
        ],
      ),
    );
  }
}


