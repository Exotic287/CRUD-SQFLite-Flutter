import 'package:sqflite/sqflite.dart' as sql;


class SQLHelper {
  //fungsi membuat tabel
  static  Future<void> createTables(sql.Database database) async {
    await database.execute("""
                              CREATE TABLE presensi(
                                id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
                                nim VARCHAR(20),
                                nama VARCHAR(30),
                                tanggal DATE,
                                jam_masuk TIME,
                                jam_pulang TIME
                              )
                              """);
  }// buat tabel

  //Database
  static Future<sql.Database> database() async {
    return sql.openDatabase('akademik', version: 1, onCreate: (sql.Database database, int version) async {
      await createTables(database);
    });
  }

  //Fungsi tambahData
  static Future<int> tambahData(String nim, String nama,String tanggal, String jam_masuk, String jam_pulang) async {
    final database = await SQLHelper.database();
    final data = {'nim' : nim, 'nama' : nama, 'tanggal':tanggal, 'jam_masuk':jam_masuk,'jam_pulang':jam_pulang};
    return await database.insert('presensi', data);
  }

  //Fungsi Ambil Data
  static Future<List<Map<String, dynamic>>> ambilData() async {
    final database = await SQLHelper.database();
    return database.query('presensi');
  }

  //Fungsi Ubah Data
  static Future<int> ubahData(int id, String nim, String nama, String tanggal, String jam_masuk, String jam_pulang ) async {
    final database = await SQLHelper.database();
    final data = {'nim' : nim, 'nama' : nama, 'tanggal':tanggal, 'jam_masuk':jam_masuk,'jam_pulang':jam_pulang};
    return await database.update('presensi', data, where: "id = $id");
  }

  //Fungsi Hapus Data
  static Future<int> hapusData (int id)async {
    final database = await SQLHelper.database();
    return await database.delete('presensi', where: "id = $id");
  }
  
}