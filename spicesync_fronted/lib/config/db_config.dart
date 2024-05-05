import 'package:mysql_client/mysql_client.dart';

class DbConfig {
  static const host = "127.0.0.1";
  static const port = 3306;
  static const userName = "root";
  static const password = "root";
  static const databaseName = "spicesync";

  static Future<MySQLConnection> getConnection() async {
    final conn = await MySQLConnection.createConnection(
      host: host,
      port: port,
      userName: userName,
      password: password,
      databaseName: databaseName,
    );

    await conn.connect();

    return conn;
  }
}