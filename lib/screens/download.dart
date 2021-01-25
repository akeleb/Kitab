import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kitabui/reader/listbooks.dart';
import 'package:kitabui/reader/searchkitab.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path_provider_ex/path_provider_ex.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path;
import '../consts.dart' as consts;

class Kdownload extends StatefulWidget {
  Kdownload(KitBooks book, {Key key, this.title}) : super(key: key) {
    books = book;
  }
  final String title;
  KitBooks books;

  @override
  KdownloadState createState() => KdownloadState(books);
}

class KdownloadState extends State<Kdownload> {
  KdownloadState(KitBooks books) {
    book = books;
    fileName = book.id.toString() + ".pdf";
  }
  static KitBooks book;
  var fileUrl = Uri(
      scheme: 'http',
      host: consts.location,
      path: "/cntnt/"+book.id.toString()+".pdf").toString();
  String fileName;
  final Dio dio = Dio();
  String progress = "";

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  @override
  void initState() {
    super.initState();

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final iOS = IOSInitializationSettings();
    final initSettings = InitializationSettings(android, iOS);
    flutterLocalNotificationsPlugin.initialize(initSettings, onSelectNotification: onSelectNotification);
  }

  Future<void> onSelectNotification(String json) async {
    final obj = jsonDecode(json);

    if (obj['isSuccess']) {
      OpenFile.open(obj['filePath']);
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Error'),
          content: Text('${obj['error']}'),
        ),
      );
    }
  }

//  Future<void> showNotification(Map<String, dynamic> downloadStatus) async {
//    final android = AndroidNotificationDetails(
//        'channel id',
//        'channel name',
//        'channel description',
//        priority: Priority.High,
//        importance: Importance.Max
//    );
//    final iOS = IOSNotificationDetails();
//    final platform = NotificationDetails(android, iOS);
//    final json = jsonEncode(downloadStatus);
//    final isSuccess = downloadStatus['isSuccess'];
//
//    await flutterLocalNotificationsPlugin.show(
//        0, // notification id
//        isSuccess ? 'Success' : 'Failure',
//        isSuccess ? 'File has been downloaded successfully!'
//            : 'There was an error while downloading the file.',
//        platform,
//        payload: json
//    );
//  }


  Future<Directory> getDownloadDirectory() async {
    if (Platform.isAndroid) {
      List<StorageInfo> storageInfo = await PathProviderEx.getStorageInfo();
      final Directory appDir= await getApplicationDocumentsDirectory();
      final Directory appFolder= Directory('$appDir/KitabBooks');
      if(await appFolder.exists()){
        return appFolder;
      }
      return new Directory(storageInfo[0].rootDir+'/KitabBooks').create();
    }

    // in this example we are using only Android and iOS so I can assume
    // that you are not trying it for other platforms and the if statement
    // for iOS is unnecessary

    // iOS directory visible to user
    return await getApplicationDocumentsDirectory();
  }

  Future<bool> requestPermissions() async {
    var permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);

    if (permission != PermissionStatus.granted) {
      await PermissionHandler().requestPermissions([PermissionGroup.storage]);
      permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
    }

    return permission == PermissionStatus.granted;
  }

  void onReceiveProgress(int received, int total) {
    if (total != -1) {
      setState(() {
        progress = (received / total * 100).toStringAsFixed(0) + "%";
      });
    }
  }

  Future<void> startDownload(String savePath) async {
    Map<String, dynamic> result = {
      'isSuccess': false,
      //'filePath': null,
      'error': null,
    };

    try {
      final response = await dio.download(
          fileUrl,
          savePath,
          onReceiveProgress: onReceiveProgress
      );
      result['isSuccess'] = response.statusCode == 200;
      result['filePath'] = savePath;
    } catch (ex) {
      result['error'] = ex.toString();
    } finally {
      savePath=null;
    }
  }

  Future<void> download() async {
    final dir = await getDownloadDirectory();
    final isPermissionStatusGranted = await requestPermissions();

    if (isPermissionStatusGranted) {
      final savePath = path.join(dir.path, fileName);
      await startDownload(savePath);
    } else {
      // handle the scenario when user declines the permissions
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: Text("Download"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              ' Click Below button \nto download this book',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'OpenSans',
              ),
            ),
            Text(
              '$progress',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        child: FloatingActionButton(
          onPressed: download,
          tooltip: 'Download',
          child: Icon(Icons.file_download),
        ),
      ),
    );
  }
}