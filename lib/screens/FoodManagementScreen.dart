import 'package:flutter/material.dart';
import '../utils/database_helper.dart';

class FoodManagementScreen extends StatefulWidget {
  @override
  _FoodManagementScreenState createState() => _FoodManagementScreenState();
}

class _FoodManagementScreenState extends State<FoodManagementScreen> {
  final dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> _foodItems = [];

  @override
  void initState() {
    super.initState();
    _fetchFoodItems();
  }

  Future<void> _fetchFoodItems() async {
    final db = await dbHelper.database;
    final foodData = await db.query('food');
    setState(() {
      _foodItems = foodData;
    });
  }

  Future<void> _deleteFoodItem(int id) async {
    final db = await dbHelper.database;
    await db.delete('food', where: 'id = ?', whereArgs: [id]);
    _fetchFoodItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Manage Food Items')),
      body: ListView.builder(
        itemCount: _foodItems.length,
        itemBuilder: (context, index) {
          final food = _foodItems[index];
          return ListTile(
            title: Text('${food['name']} (\$${food['cost']})'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _deleteFoodItem(food['id']),
            ),
          );
        },
      ),
    );
  }
}
