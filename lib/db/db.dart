import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:fish/pages/blog_page.dart';
import 'package:fish/pages/notes_page.dart';
import 'dart:convert';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:fish/pages/main_page.dart';
import 'package:path_provider/path_provider.dart';

Future<String> dbInit(String name) async{
  // Get a location using getDatabasesPath
  Directory documentDic = await getApplicationDocumentsDirectory();
  print(documentDic.path+"/fish.db");
  var databasesPath = await getDatabasesPath();
  String path = documentDic.path+"/fish.db";



// Delete the database
//  await deleteDatabase(path);

// 创建数据库
  Database database = await openDatabase(path, version: 1,
      onCreate: (Database db, int version) async {
        // When creating the db, create the table
        await db.execute(
            'CREATE TABLE  config(name VARCHAR(255),id INTEGER PRIMARY KEY, value TEXT)');
      });
 /* var count = await database
      .rawDelete('DELETE FROM config ');*/

  List<Map> firstOpen=await database.rawQuery('SELECT *  FROM config where name = "first_open"');
  if(firstOpen.length>0){
    print("这个用户不是第一次惹");
  }
  // Insert some records in a transaction
  await database.transaction((txn) async {
   int id1 = await txn.rawInsert(
        'INSERT INTO config(name, value) VALUES("first_open", 1  )');
    int id2 = await txn.rawInsert(
        'INSERT INTO config(name, value) VALUES("xixixi", 2  )');
    print('inserted1: $id2+$id2');
    /*int id2 = await txn.rawInsert(
        'INSERT INTO Test(name, value, num) VALUES(?, ?, ?)',
        ['another name', 12345678, 3.1416]);
    print('inserted2: $id2');*/
  });

// Update some record
 /* int count = await database.rawUpdate(
      'UPDATE Test SET name = ?, VALUE = ? WHERE name = ?',
      ['updated name', '9876', 'some name']);
  print('updated: $count');
*/
// Get the records
  List<Map> list = await database.rawQuery('SELECT * FROM config');
 /* List<Map> expectedList = [
    {'name': 'updated name', 'id': 1, 'value': 9876, 'num': 456.789},
    {'name': 'another name', 'id': 2, 'value': 12345678, 'num': 3.1416}
  ];*/
  print(list);
 /* print(expectedList);
  assert(const DeepCollectionEquality().equals(list, expectedList));

// Count the records
  count = Sqflite
      .firstIntValue(await database.rawQuery('SELECT COUNT(*) FROM Test'));
  assert(count == 2);

 //Delete a record
  count = await database
      .rawDelete('DELETE FROM Test WHERE name = ?', ['another name']);
  assert(count == 1);*/

// Close the database
  await database.close();

}

