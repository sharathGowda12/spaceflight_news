import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

String sqfliteTableName = 'FavouritedNews';

// Creates sqflite persistance database.
class DbHelper {
  static Future<Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'spaceFlightDatabase.db'),
        onCreate: (db, version) async {
      await db.execute('CREATE TABLE $sqfliteTableName' // return
          '(id TEXT PRIMARY KEY,'
          'title TEXT,'
          'url TEXT,' 
          'imageUrl TEXT,' 
          'dateMS INTEGER,' //Published Time in milliseconds for easy sorting.
          'publishedAt TEXT )');
        }, version: 1);
  }


// TO insert articles to database
static Future<void> insertToFavourites(Map<String, dynamic> data) async {
    final db = await DbHelper.database();
    db.insert(sqfliteTableName,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  // TO get all the favorited articles
  static Future<List<Map<String, dynamic>>> getFavouritedNews() async {
    final db = await DbHelper.database();
    return db.query(sqfliteTableName,
        orderBy: 'dateMS DESC',); 
  }

  // Favorited articles will be removed by taking 'id' as argument.
  static Future<void> removeFavorite(String idOfNews) async {
    final db = await DbHelper.database();
    db.delete(sqfliteTableName, where: 'id = ?', whereArgs: [idOfNews]);
  }

}

// used in 01A_news_main_card.dart
// To add or insert data to sqflite.
  void addNewsToFavorites(String id01, String title01, String webUrl01, 
            String imageUrl01, String publishedDate01) async{
    int _dateInMilliSeconds = DateTime.parse(publishedDate01).millisecondsSinceEpoch;
    Map<String, dynamic>  _sqfliteData = {
      'id': id01,
      'title': title01,
      'url': webUrl01,
      'imageUrl': imageUrl01,
      'dateMS': _dateInMilliSeconds,
      'publishedAt': publishedDate01,
    };

    await DbHelper.insertToFavourites(_sqfliteData);
  }
  
// used in 01A_news_main_card.dart
  void removeNewsFromFavorites(String id01) async{
    await DbHelper.removeFavorite(id01);
  }