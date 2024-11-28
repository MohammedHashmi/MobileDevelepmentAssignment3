import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    return await openDatabase(
      join(dbPath, 'food_ordering.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE food(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            cost REAL
          )
        ''');
        await db.execute('''
          CREATE TABLE order_plan(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            date TEXT,
            target_cost REAL,
            selected_food_ids TEXT
          )
        ''');
      },
    );
  }


  Future<List<Map<String, dynamic>>> fetchFoodItems() async {
    final db = await database;
    return await db.query('food');
  }


  Future<void> addFoodItem(String name, double cost) async {
    final db = await database;
    await db.insert('food', {'name': name, 'cost': cost});
  }

  Future<void> deleteFoodItem(int id) async {
    final db = await database;
    await db.delete('food', where: 'id = ?', whereArgs: [id]);
  }


  Future<void> saveOrderPlan(String date, double targetCost, List<int> selectedFoodIds) async {
    final db = await database;
    await db.insert('order_plan', {
      'date': date,
      'target_cost': targetCost,
      'selected_food_ids': selectedFoodIds.join(',')
    });
  }


  Future<void> updateOrderPlan(int id, String date, double targetCost, List<int> selectedFoodIds) async {
    final db = await database;
    await db.update(
      'order_plan',
      {
        'date': date,
        'target_cost': targetCost,
        'selected_food_ids': selectedFoodIds.join(',')
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> fetchOrderPlanByDate(String date) async {
    final db = await database;
    return await db.query('order_plan', where: 'date = ?', whereArgs: [date]);
  }

  // Delete order plan
  Future<void> deleteOrderPlan(int id) async {
    final db = await database;
    await db.delete('order_plan', where: 'id = ?', whereArgs: [id]);
  }
}
