import 'package:flutter/material.dart';
import 'order_plan_screen.dart';
import 'food_management_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Ordering App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OrderPlanScreen()),
                );
              },
              child: Text('Create/View Order Plan'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FoodManagementScreen()),
                );
              },
              child: Text('Manage Food Items'),
            ),
          ],
        ),
      ),
    );
  }
}
