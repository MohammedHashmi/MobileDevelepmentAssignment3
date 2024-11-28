import 'package:flutter/material.dart';
import '../utils/database_helper.dart';

class OrderPlanScreen extends StatefulWidget {
  @override
  _OrderPlanScreenState createState() => _OrderPlanScreenState();
}

class _OrderPlanScreenState extends State<OrderPlanScreen> {
  final dbHelper = DatabaseHelper();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _targetCostController = TextEditingController();
  final TextEditingController _searchDateController = TextEditingController();

  List<Map<String, dynamic>> _foodItems = [];
  List<int> _selectedFoodIds = [];
  List<Map<String, dynamic>> _searchedPlans = [];

  @override
  void initState() {
    super.initState();
    _loadFoodItems();
  }

  Future<void> _loadFoodItems() async {
    final items = await dbHelper.fetchFoodItems();
    setState(() {
      _foodItems = items;
    });
  }

  Future<void> _saveOrderPlan() async {
    final date = _dateController.text;
    final targetCost = double.tryParse(_targetCostController.text) ?? 0.0;

    if (_selectedFoodIds.isEmpty || date.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill in all fields.')));
      return;
    }

    await dbHelper.saveOrderPlan(date, targetCost, _selectedFoodIds);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Order saved!')));
    _clearInputs();
  }

  Future<void> _searchPlansByDate() async {
    final date = _searchDateController.text;
    if (date.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Enter a date to search.')));
      return;
    }

    final plans = await dbHelper.fetchOrderPlanByDate(date);
    setState(() {
      _searchedPlans = plans;
    });
  }

  Future<void> _deletePlan(int id) async {
    await dbHelper.deleteOrderPlan(id);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Plan deleted!')));
    _searchPlansByDate(); // Refresh the searched results
  }

  void _clearInputs() {
    _dateController.clear();
    _targetCostController.clear();
    _selectedFoodIds.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Manage Order Plans')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _dateController,
              decoration: InputDecoration(labelText: 'Date (YYYY-MM-DD)'),
            ),
            TextField(
              controller: _targetCostController,
              decoration: InputDecoration(labelText: 'Target Cost'),
              keyboardType: TextInputType.number,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _foodItems.length,
                itemBuilder: (context, index) {
                  final food = _foodItems[index];
                  return CheckboxListTile(
                    title: Text('${food['name']} (\$${food['cost']})'),
                    value: _selectedFoodIds.contains(food['id']),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          _selectedFoodIds.add(food['id']);
                        } else {
                          _selectedFoodIds.remove(food['id']);
                        }
                      });
                    },
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _saveOrderPlan,
              child: Text('Save Order Plan'),
            ),
            Divider(),
            TextField(
              controller: _searchDateController,
              decoration: InputDecoration(labelText: 'Search Date (YYYY-MM-DD)'),
            ),
            ElevatedButton(
              onPressed: _searchPlansByDate,
              child: Text('Search Plans'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _searchedPlans.length,
                itemBuilder: (context, index) {
                  final plan = _searchedPlans[index];
                  return ListTile(
                    title: Text('Date: ${plan['date']} - \$${plan['target_cost']}'),
                    subtitle: Text('Food IDs: ${plan['selected_food_ids']}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _deletePlan(plan['id']),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
