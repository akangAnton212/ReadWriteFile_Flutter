import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

void main() => runApp(MyApp());

class MyStorage {

  //get directory path
  Future<String> get localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  //get file
  Future<File> get localFile async {
    final path = await localPath;
    return File("$path/contoh.txt");
  }

  //read file
  Future<String> readFile() async {
    try {
      final file  = await localFile;
      String content  = await file.readAsString();
      return content;
    } catch (e) {
      return null;
    }
  }

  //write file
  Future<File> writeContent(String content) async {
    final file =  await localFile;
    return file.writeAsString("$content");
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "File Manager",
      home: MyHomePage(storage:MyStorage()),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final MyStorage storage;
  MyHomePage({Key key, this.storage}):super(key:key);


  @override
  State<StatefulWidget> createState() => DisplayScreen();
}

class DisplayScreen extends State<MyHomePage> {

  //buat controller untuk ngambil  text
  final controller_text_data = TextEditingController();
  String text_read = "";

  Future<File> saveToFile() async {
    setState(() {
     text_read = controller_text_data.text; 
    });
 
    return widget.storage.writeContent(text_read);
  }

  @override
  void initState() {
    super.initState();
    widget.storage.readFile().then((String value){
      setState(() {
       text_read = value; //ambil text defaultnya 
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('File Manager'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          //text fields
          TextField(
            decoration: InputDecoration(
              hintText: 'Masukan data',
            ),
            controller: controller_text_data,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //tombol save
              Padding(
                padding: EdgeInsets.all(10.0),
                child: RaisedButton(
                  onPressed: () {saveToFile();},
                  child: Text("Simpan"),
                ),
              ),

              //tombol read
              Padding(
                padding: EdgeInsets.all(10.0),
                child: RaisedButton(
                  onPressed: () {readFile();},
                  child: Text("Read"),
                ),
              )
            ],
          ),
          Text('$text_read')
        ],
      ),
    );
  }

  void readFile() {
    widget.storage.readFile().then((String value){
      setState(() {
        text_read = value; 
      });
    });
  }
  
}
