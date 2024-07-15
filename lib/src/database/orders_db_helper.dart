import 'dart:convert';

import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart';

class SQLOrderHelper {
  static Future<void> createTables(sql.Database database) async {
    // Create the orders table
    await database.execute("""CREATE TABLE orders(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      createdAt TEXT,
      orderNumber TEXT UNIQUE,
      total TEXT,

      items TEXT
    )""");
  }

  static Future<void> deleteDatabase() async {
    await sql.deleteDatabase("order_data.db");
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      join(await sql.getDatabasesPath(), 'order_data.db'),
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  static Future<int> createOrder(Order order) async {
    final db = await SQLOrderHelper.db();
    final orderId = await db.insert(
      'orders',
      {
        'createdAt': order.createdAt,
        'orderNumber': order.orderNumber,
        'total': order.total,
        'items': jsonEncode(order.items
            .map((item) => item.toJson())
            .toList()), // Use toJson for serialization
      },
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );

    return orderId;
  }

  static Future<List<Order>> getAllOrders() async {
    final db = await SQLOrderHelper.db();
    final List<Map<String, dynamic>> orderMaps =
        await db.query('orders', orderBy: 'createdAt DESC');

    return List.generate(orderMaps.length, (i) {
      return Order.fromMap(orderMaps[i]);
    });
  }
}

class Order {
  String createdAt;
  String orderNumber;
  String total;
  List<Item> items;

  Order({
    required this.createdAt,
    required this.total,
    required this.orderNumber,
    required this.items,
  });

  Map<String, dynamic> toMap() {
    return {
      'createdAt': createdAt,
      'orderNumber': orderNumber,
      'total': total,
      'items': items.map((item) => item.toMap()).toList(),
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      createdAt: map['createdAt'],
      total: map['total'],
      orderNumber: map['orderNumber'],
      items: (jsonDecode(map['items']) as List<dynamic>)
          .map((data) => Item.fromMap(data))
          .toList(),
    );
  }
}

class Item {
  String title;
  String imageUrl;
  String count;
  String size;
  String color;
  double price;

  Item({
    required this.title,
    required this.imageUrl,
    required this.count,
    required this.size,
    required this.color,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'price': price,
      'imageUrl': imageUrl,
      'count': count,
      'size': size,
      'color': color,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      title: map['title'],
      price: map['price']?.toDouble() ?? 0.0,
      imageUrl: map['imageUrl'],
      count: map['count'],
      size: map['size'],
      color: map['color'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'price': price,
      'imageUrl': imageUrl,
      'count': count,
      'color': color,
      'size': size,
    };
  }

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      title: json['title'],
      price: json['price']?.toDouble() ?? 0.0,
      imageUrl: json['imageUrl'],
      count: json['count'],
      size: json['size'],
      color: json['color'],
    );
  }
}
