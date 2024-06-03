// ignore_for_file: empty_catches, constant_identifier_names

import 'package:app/model/user_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbHelper {
  static final DbHelper instance = DbHelper();
  static Database? _db;
  //variables
  static const String dbName = 'my_app.db';
  static const int version = 1;

//for table users
  static const String tableUser = 'user';
  static const String uid = 'id';
  static const String fname = 'first_name';
  static const String lname = 'last_name';
  static const String Email = 'email';
  static const String bDate = 'date_of_birth';
  static const String password = 'password';
  static const String profileImage = 'profile_photo';

//for table chronics
  static const String tableChronics = 'chronics';
  static const String chroniId = 'id';
  static const String userIds = 'user_id';
  static const String chronicTitle = 'title';

//for table symptoms
  static const String tableSymptoms = 'symptoms';
  static const String symptomId = 'id';
  static const String userId = 'user_id';
  static const String symptomTitle = 'symptom_title';
  static const String symptomDescription = 'description';
  static const String symptomFrom = 'from_date';
  static const String symptomTo = 'to_date';
  static const String symptomIntensity = 'intensity';

//for table pain
  static const String tablePain = 'pains';
  static const String painId = 'pain_id';
  static const String painuserId = 'pain_user_id';
  static const String painDescription = 'pain_description';
  static const String painFrom = 'from_date';
  static const String painTo = 'to_date';
  static const String painIntensity = 'pain_intensity';

  Future<Database?> get db async {
    _db = await initDb();

    return _db;
  }

  initDb() async {
    String path = join(await getDatabasesPath(), dbName);
    var db = await openDatabase(path, version: version, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        '''
      CREATE TABLE $tablePain(
        $painId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        $painuserId TEXT,
        $painDescription TEXT NOT NULL,
        $painFrom TEXT,
        $painTo TEXT,
        $painIntensity INT NOT NULL
      )
    ''');
    await db.execute(
        '''
      CREATE TABLE $tableSymptoms(
        $symptomId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        $userId TEXT,
        $symptomTitle TEXT NOT NULL,
        $symptomDescription TEXT NOT NULL,
        $symptomFrom TEXT,
        $symptomTo TEXT,
        $symptomIntensity INT NOT NULL
      )
    ''');
    await db.execute(
        '''
          CREATE TABLE $tableChronics(
            $chroniId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            $userIds TEXT,
            $chronicTitle TEXT NOT NULL
          )
        ''');
    await db.execute("CREATE TABLE $tableUser ("
        "$fname VARCHAR NOT NULL, "
        "$lname VARCHAR NOT NULL, "
        "$Email VARCHAR NOT NULL, "
        "$bDate VARCHAR NOT NULL, "
        "$password VARCHAR NOT NULL, "
        "$profileImage VARCHAR NOT NULL, "
        "PRIMARY KEY ($Email)"
        ")");
  }

// USER REGISTRATION
  Future<int> saveData(UserModel user) async {
    var dbClient = await db;
    var res = await dbClient!.insert(tableUser, user.toMap());
    return res;
  }

  Future<UserModel?> getLoginUser(String email, String upass) async {
    var dbClient = await db;
    var res = await dbClient!.rawQuery("SELECT * FROM $tableUser WHERE "
        "$Email = '$email' AND "
        "$password = '$upass' ");

    if (res.isNotEmpty) {
      return UserModel.formMap(res.first);
    }
    return null;
  }

  Future<int> updateUser(UserModel user) async {
    var dbClient = await db;
    var res = await dbClient!.update(tableUser, user.toMap(),
        where: '$Email=?', whereArgs: [user.email]);
    return res;
  }

  Future<UserModel?> checkEmail(String email) async {
    var dbClient = await db;
    var res = await dbClient!.rawQuery("SELECT * FROM $tableUser WHERE "
        "$Email = '$email'  ");

    if (res.isNotEmpty) {
      return null;
    }
    return UserModel(fname, lname, email, bDate, password, profileImage);
  }

  Future<String?> getUserProfileImage(String email) async {
    final dbClient = await db;
    final res = await dbClient!.query(
      tableUser,
      columns: [profileImage],
      where: '$Email = ?',
      whereArgs: [email],
      limit: 1,
    );

    if (res.isNotEmpty) {
      return res.first[profileImage] as String?;
    }
    return null;
  }

  // Method to check if the email exists in the database
  Future<bool> checkEmailExistence(String email) async {
    var dbClient = await db;
    var res = await dbClient!
        .rawQuery("SELECT * FROM $tableUser WHERE $Email = '$email'");

    return res.isNotEmpty;
  }

  // Method to retrieve the password associated with the email
  Future<String?> getPassword(String email) async {
    var dbClient = await db;
    var res = await dbClient!
        .rawQuery("SELECT $password FROM $tableUser WHERE $Email = '$email'");

    if (res.isNotEmpty) {
      return res.first[password] as String?;
    }
    return null;
  }

//----------------------------------------------------//

  //CHRONICS TABLE

//insert
  static Future<int> insertProblem(String userId, String title) async {
    final dbClient = DbHelper._db;
    final data = {'user_id': userId, 'title': title};
    final id = await dbClient!.insert(tableChronics, data,
        conflictAlgorithm: ConflictAlgorithm.replace);

    return id;
  }

  //get all
  static Future<List<Map<String, dynamic>>> getAllProblems(
      String userId) async {
    final dbClient = DbHelper._db;
    return dbClient!.query(tableChronics,
        where: '$userIds = ?', whereArgs: [userId], orderBy: chroniId);
  }

  //get single
  static Future<List<Map<String, dynamic>>> getSingleProblems(int id) async {
    final dbClient = DbHelper._db;
    return dbClient!.query(tableChronics,
        where: '$chroniId = ?', whereArgs: [id], limit: 1);
  }

  //update
  static Future<int> updateProb(int id, String title) async {
    final dbClient = DbHelper._db;
    final data = {
      chronicTitle: title,
    };
    var res = await dbClient!
        .update(tableChronics, data, where: '$chroniId = ?', whereArgs: [id]);
    return res;
  }

//delete
  static Future<void> deleteProb(int id) async {
    final dbClient = DbHelper._db;
    try {
      dbClient!.delete(tableChronics, where: '$chroniId = ?', whereArgs: [id]);
    } catch (e) {}
  }

  //=====================================================================//

  //SYMPOTM TABLE

//insert
  static Future<int> insertSymptom(String userId, String title, String desc,
      DateTime from, DateTime to, String intens) async {
    final dbClient = DbHelper._db;
    final data = {
      'user_id': userId,
      'symptom_title': title,
      'description': desc,
      'from_date': from.toIso8601String(),
      'to_date': to.toIso8601String(),
      'intensity': intens,
    };
    final id = await dbClient!.insert(tableSymptoms, data,
        conflictAlgorithm: ConflictAlgorithm.replace);

    return id;
  }

  //get all
  static Future<List<Map<String, dynamic>>> getAllSymptoms(
      String userIds) async {
    final dbClient = DbHelper._db;
    return dbClient!.query(tableSymptoms,
        where: '$userId = ?', whereArgs: [userIds], orderBy: symptomId);
  }

  //get all for chart
  Future<List<Map<String, dynamic>>> getAllSymptomss(String userIds) async {
    final dbClient = DbHelper._db;
    return dbClient!.query(tableSymptoms,
        where: '$userId = ?', whereArgs: [userIds], orderBy: symptomId);
  }

  //get single
  static Future<List<Map<String, dynamic>>> getSingleSymptom(int id) async {
    final dbClient = DbHelper._db;
    return dbClient!.query(tableSymptoms,
        where: '$symptomId = ?', whereArgs: [id], limit: 1);
  }

  //update
  static Future<int> updateSymptom(int id, String title) async {
    final dbClient = DbHelper._db;
    final data = {
      symptomTitle: title,
    };
    var res = await dbClient!
        .update(tableSymptoms, data, where: '$symptomId = ?', whereArgs: [id]);
    return res;
  }

//delete
  static Future<void> deleteSymptom(int id) async {
    final dbClient = DbHelper._db;
    try {
      dbClient!.delete(tableSymptoms, where: '$symptomId = ?', whereArgs: [id]);
    } catch (e) {}
  }

  //=====================================================================//
  //PAIN TABLE

//insert
  static Future<int> insertPain(String painUserid, String painDesc,
      DateTime from, DateTime to, String painIntens) async {
    final dbClient = DbHelper._db;
    final data = {
      'pain_user_id': painUserid,
      'pain_description': painDesc,
      'from_date': from.toIso8601String(),
      'to_date': to.toIso8601String(),
      'pain_intensity': painIntens,
    };
    final id = await dbClient!
        .insert(tablePain, data, conflictAlgorithm: ConflictAlgorithm.replace);

    return id;
  }

  //get all
  static Future<List<Map<String, dynamic>>> getAllPains(String userIdss) async {
    final dbClient = DbHelper._db;
    return dbClient!.query(tablePain,
        where: '$painuserId = ?', whereArgs: [userIdss], orderBy: painId);
  }

  //get all for chart
  Future<List<Map<String, dynamic>>> getAllPainss(String userIdss) async {
    final dbClient = DbHelper._db;
    return dbClient!.query(tablePain,
        where: '$painuserId = ?', whereArgs: [userIdss], orderBy: painId);
  }

  //get single
  static Future<List<Map<String, dynamic>>> getSinglePain(int id) async {
    final dbClient = DbHelper._db;
    return dbClient!
        .query(tablePain, where: '$painId = ?', whereArgs: [id], limit: 1);
  }

  //update
  static Future<int> updatePain(int id, String desc) async {
    final dbClient = DbHelper._db;
    final data = {
      painDescription: desc,
    };
    var res = await dbClient!
        .update(tablePain, data, where: '$painId = ?', whereArgs: [id]);
    return res;
  }

//delete
  static Future<void> deletePain(int id) async {
    final dbClient = DbHelper._db;
    try {
      dbClient!.delete(tablePain, where: '$painId = ?', whereArgs: [id]);
    } catch (e) {}
  }

  //=====================================================================//
}
