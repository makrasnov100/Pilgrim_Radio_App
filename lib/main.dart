import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'services/locator.dart';

import 'pages/channel_page.dart';
import 'pages/contact_page.dart';

import 'package:voice_of_pilgrim/services/bg_audio_task.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  MyApp()
  {
    setupSingleton();
  }

  
  Map<int, Color> colorCodes = {
    50: Color.fromRGBO(59, 61, 126, .1),
    100: Color.fromRGBO(59, 61, 126, .2),
    200: Color.fromRGBO(59, 61, 126, .3),
    300: Color.fromRGBO(59, 61, 126, .4),
    400: Color.fromRGBO(59, 61, 126, .5),
    500: Color.fromRGBO(59, 61, 126, .6),
    600: Color.fromRGBO(59, 61, 126, .7),
    700: Color.fromRGBO(59, 61, 126, .8),
    800: Color.fromRGBO(59, 61, 126, .9),
    900: Color.fromRGBO(59, 61, 126, 1),
  };



  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    // Green color code: FF93cd48
    MaterialColor customColor = MaterialColor(0xFF323d7e, colorCodes);

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: customColor,//Color.fromRGBO(50, 61, 126, 1.0),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: AudioServiceWidget(
        child: MyHomePage(
          title: 'The Voice of Pilgrim'
        )
      ),
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
  //Tab Pages
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    AudioService.start(backgroundTaskEntrypoint: myBackgroundAudioTaskEntrypoint);
  }

  @override
  void dispose() {
    // TODO: should audio service be stopped here?
    super.dispose();
  }

  void onTabTapped(int index) async
  {
    setState(() {_currentIndex = index;});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(widget.title,
              textAlign: TextAlign.center,
              ),
          ),
        ),
        body: Column(
          children: [
            Visibility(
              visible: _currentIndex == 0,
              child: ChannelPage(
                streamURL: "http://37.187.112.164:8000/stream", 
                statsURL: "http://37.187.112.164:8000/stats",
                streamId: 0,
              ),
            ),
            Visibility(
              visible: _currentIndex == 1,
              child: ChannelPage(
                streamURL: "http://ca.rcast.net:8010/stream", 
                statsURL: "http://ca.rcast.net:8010/stats",
                streamId: 1,
              )
            ),
            Visibility(
              visible: _currentIndex == 2,
              child: ContactPage(),
            ),
          ],
        ), 
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: onTabTapped,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.radio),
              title: new Text("Main Radio"),
            ),
            BottomNavigationBarItem(
              icon: new Icon(FontAwesomeIcons.broadcastTower),
              title: new Text("Youth Radio"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.feedback),
              title: Text("Contact Us")
            )
          ],
        ),
      ),
    );
  }
}
