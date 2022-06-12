import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dbhelper.dart';
import 'package:flutter/foundation.dart';
import 'dart:ffi';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CRUD',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'CRUD - SQFLite'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, @required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  //variabel untuk controller
  TextEditingController nimController = TextEditingController();
  TextEditingController namaController = TextEditingController();
  TextEditingController tanggalController = TextEditingController();
  TextEditingController jammasukController = TextEditingController();
  TextEditingController jampulangController = TextEditingController();

  @override
  void initState() {
    refreshData();
    super.initState();
  }

  //ambil data dari database
  List<Map<String, dynamic>> presensi = [];
  void refreshData() async {
    final data = await SQLHelper.ambilData();
    setState(() {
      presensi = data;
    });
  }

  //

  @override
  Widget build(BuildContext context) {
    print(presensi);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: presensi.length,
        itemBuilder: (context, index) => Card(
          margin: const EdgeInsets.all(15),
          child: ListTile(
            title: SizedBox(
              height: 30,
              width: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    child: Row(
                      children: [
                        Text(presensi[index]['nim']),
                        Text(" - "),
                        Text(presensi[index]['nama'])
                      ],
                    ),
                  ),
                ],
              ),
            ),
            subtitle: SizedBox(
              width: 100,
              height: 50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    child: Row(
                      children: [
                        Text("Tanggal : "),
                        Text(presensi[index]['tanggal'])
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      children: [
                        Text("Jam Masuk : "),
                        Text(presensi[index]['jam_masuk'])
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      children: [
                        Text("Jam Pulang : "),
                        Text(presensi[index]['jam_pulang'])
                      ],
                    ),
                  ),
                ],
              ),
            ),
            trailing: SizedBox(
              width: 100,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => modalForm(presensi[index]['id']),
                    icon: const Icon(Icons.edit),
                  ),
                  IconButton(
                    onPressed: () => pesanHapus(presensi[index]['id']),
                    icon: const Icon(Icons.delete),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          modalForm(null);
          //proses
        },
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  //fungsi tambah
  Future<Void> tambahdataPresensi() async {
    await SQLHelper.tambahData(nimController.text,namaController.text, tanggalController.text, jammasukController.text,jampulangController.text);
    refreshData();
  }

  //fungsi ubah
  Future<Void> ubahdataPrsensi(int id) async {
    await SQLHelper.ubahData(id,nimController.text,namaController.text, tanggalController.text, jammasukController.text,jampulangController.text);
    refreshData();
  }

  //fungsi hapus
  Future<Void> hapusdataPresensi(int id) async {
    await SQLHelper.hapusData(id);
    refreshData();
  }

  void pesanHapus(int id) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text('Hapus Data Ini?'),
            actions: <Widget>[
              RaisedButton(
                child: Icon(Icons.cancel),
                color: Colors.red,
                textColor: Colors.white,
                onPressed: () => Navigator.of(context).pop(),
              ),
              RaisedButton(
                child: Icon(Icons.check_circle),
                color: Colors.blue,
                textColor: Colors.white,
                onPressed: () => hapusdataPresensi(id),
              )
            ],
          );
        });
  }

  //form tambah
  void modalForm(int id) async {
    if (id != null) {
      final dataAnggota = presensi.firstWhere((element) => element['id'] == id);
      nimController.text = dataAnggota['nim'];
      namaController.text = dataAnggota['nama'];
      tanggalController.text = dataAnggota['tanggal'];
      jammasukController.text = dataAnggota['jam_masuk'];
      jampulangController.text = dataAnggota['jam_pulang'];
    } else {
      nimController.text = '';
      namaController.text = '';
      tanggalController.text = '';
      jammasukController.text = '';
      jampulangController.text = '';
    }

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) => Container(
              padding: const EdgeInsets.all(15),
              width: double.infinity,
              height: 800,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    TextField(
                      controller: nimController,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: 'NIM',
                        hintStyle: const TextStyle(color: Colors.black),
                        labelText: 'Masukan NIM',
                        labelStyle: const TextStyle(color: Colors.black),
                      ),
                      
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextField(
                      controller: namaController,
                      decoration: InputDecoration(
                        hintText: 'NAMA',
                        hintStyle: const TextStyle(color: Colors.black),
                        labelText: 'Masukan Nama',
                        labelStyle: const TextStyle(color: Colors.black),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextField(
                      controller: tanggalController,
                      decoration: InputDecoration(
                        hintText: 'YYYY-MM-DD',
                        hintStyle: const TextStyle(color: Colors.black),
                        labelText: 'Tanggal',
                        labelStyle: const TextStyle(color: Colors.black),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextField(
                      controller: jammasukController,
                      decoration: InputDecoration(
                        hintText: 'HH:MM:SS',
                        hintStyle: const TextStyle(color: Colors.black),
                        labelText: 'Jam Masuk',
                        labelStyle: const TextStyle(color: Colors.black),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextField(
                      controller: jampulangController,
                      decoration: InputDecoration(
                        hintText: 'HH:MM:SS',
                        hintStyle: const TextStyle(color: Colors.black),
                        labelText: 'Jam Pulang',
                        labelStyle: const TextStyle(color: Colors.black),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (id == null) {
                          await tambahdataPresensi();
                        } else {
                          await ubahdataPrsensi(id);
                        }
                        nimController.text = '';
                        namaController.text = '';
                        tanggalController.text = '';
                        jammasukController.text = '';
                        jampulangController.text = '';
                        Navigator.pop(context);
                      },
                      child: Text(id == null ? 'Tambah' : 'Ubah'),
                    )
                  ],
                ),
              ),
            ));
  }
}
