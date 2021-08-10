import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'Dart:math';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
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
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();
  var initializationSettingsAndroid;
  var initializationSettingsIOS;
  var initializationSettings;

  void _showNotification() async {
    const oneSec = const Duration(seconds:10);
    new Timer.periodic(oneSec, (Timer t) => _demoNotification());
    // await _demoNotification();
  }

  Future<void> _demoNotification() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'channel_ID', 'channel name', 'channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'test ticker');

    var iOSChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSChannelSpecifics);

  //   await flutterLocalNotificationsPlugin.show(0, 'eat',
  //       '食べる', platformChannelSpecifics,
  //       payload: 'test oayload');

    var words = [
      {
      'eigo': 'eat',
      'mean': '食べる'
      },
      {
      'eigo': 'enjoy',
      'mean': '楽しい'
      },
      {
      'eigo': 'sleep',
      'mean': '眠る'
      }
      ,
      {
      'eigo': 'walk',
      'mean': '歩く'
      }
      ,
      {
      'eigo': 'get',
      'mean': '得る'
      }
      ,
      {
      'eigo': 'push',
      'mean': '押す'
      }
    ];

    Random rnd;
    int min = 0;
    int max = words.length;
    rnd = new Random();
    var r = min + rnd.nextInt(max - min);

    print(words[r]['eigo']);
    print(words[r]['mean']);

    //// 1分間隔で通知
    // await flutterLocalNotificationsPlugin.periodicallyShow(0,
    //   words[r]['eigo'],
    //   words[r]['mean'],
    //   RepeatInterval.EveryMinute, platformChannelSpecifics);

    // _demoNotification関数の実行時に通知
    await flutterLocalNotificationsPlugin.show(0,
      words[r]['eigo'],
      words[r]['mean'],
      platformChannelSpecifics,
      payload: 'test oayload');
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');
    initializationSettingsIOS = new IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    initializationSettings = new InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('Notification payload: $payload');
    }
    await Navigator.push(context,
        new MaterialPageRoute(builder: (context) => new SecondRoute()));
  }

  Future onDidReceiveLocalNotification(
    int id, String title, String body, String payload) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(body),
        actions: <Widget>[
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              await Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SecondRoute()));
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showNotification,
        tooltip: 'Increment',
        child: Icon(Icons.notifications),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class SecondRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('AlertPage'),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('go Back ...'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}