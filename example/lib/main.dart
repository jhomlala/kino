import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kino/kino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  KinoPlayer kinoPlayer;

  @override
  void initState(){
    kinoPlayer = KinoBuilder.buildSimpleKinoPlayer("http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4", "/storage/emulated/0/example.srt");

    super.initState();

  }

  setupPlayer() async{
    Directory directory = await getApplicationDocumentsDirectory();
    String path = "/storage/emulated/0/example.srt";
    File file = File(path);
    bool exists= await file.exists();
    print("File exists? " + exists.toString());
    print("Path: " + path);
    kinoPlayer = KinoBuilder.buildSimpleKinoPlayer("http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4", "/storage/emulated/0/example.srt");
    askForPermission();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(

          title: Text(widget.title),
        ),
        body: Container(

            child:Center(child: kinoPlayer)));
  }

  void askForPermission() async {
    Map<PermissionGroup, PermissionStatus> permissions =
    await PermissionHandler().requestPermissions([PermissionGroup.storage]);
    //bool isShown = await PermissionHandler().shouldShowRequestPermissionRationale(PermissionGroup.storage);
  }



}
