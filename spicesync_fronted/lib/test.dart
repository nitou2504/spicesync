import 'package:mysql_client/mysql_client.dart';
// https://pub.dev/packages/mysql_client
import '/config/db_config.dart';
import 'dart:convert';



Future<void> main() async {

final conn = await DbConfig.getConnection();

var result = await conn.execute("SELECT *  FROM recipes limit 1");

print('Type: ${result.runtimeType}');

var recipe;

for (final row in result.rows) {
    recipe = row;
  }
var row =recipe;
// var ingredients = jsonDecode(row.colByName('ingredients_list'));

var method_parts = jsonDecode(row.colByName('method_parts'));

print(method_parts);
print(method_parts[0][1][0]);



// make query (notice third parameter, iterable=true)
// var result1 = await conn.execute("SELECT *  FROM recipes WHERE recipe_id = :id", {"id": 1}, true);

//result1.rowsStream.listen((row) {
  //print(row.assoc());
//});


// close the connection
await conn.close();

}
