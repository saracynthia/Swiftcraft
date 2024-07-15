import 'package:sqflite/sqflite.dart' as sql;

class SQLCartHealper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE data(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        title TEXT,
        price TEXT,
        imageurl TEXT, 
        size TEXT,
        color TEXT,            
        count INTEGER
      )""");
  }

  static Future<void> deleteDatabase() async {
    await sql.deleteDatabase("cart_data.db");
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase("cart_data.db", version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTables(database);
    });
  }

  static Future<int> createData(
    String title,
    int count,
    String price,
    String imageurl,
    String size,
    String color,
  ) async {
    final db = await SQLCartHealper.db();
    final data = {
      'title': title,
      'price': price,
      'imageurl': imageurl,
      'count': count,
      'size': size,
      'color': color,
    };
    final id = await db.insert('data', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);

    return id;
  }

  static Future<List<Map<String, dynamic>>> getAllData() async {
    final db = await SQLCartHealper.db();
    return db.query('data', orderBy: 'id');
  }

  static Future<List<Map<String, dynamic>>> getSingleData(int id) async {
    final db = await SQLCartHealper.db();
    return db.query('data', where: 'id = ?', whereArgs: [id], limit: 1);
  }

  static Future<int> updateData(int id, int count) async {
    final db = await SQLCartHealper.db();
    final data = {
      'count': count,
    };
    return await db.update('data', data, where: 'id = ?', whereArgs: [id]);
  }

  static Future<int> deleteData(int id) async {
    final db = await SQLCartHealper.db();
    try {
      return await db.delete('data', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      // ignore: avoid_print
      print(e);
      return 0;
    }
  }
}
