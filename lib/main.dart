import 'package:flutter/material.dart';
import 'package:flutter_radio/flutter_radio.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
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
  bool isPlaying = false;
  String streamURL = "http://37.187.112.164:8000/stream";
  String nowPlayingTitle = "Nothing";

  void playPauseRadio()
  {
    isPlaying = !isPlaying;
    if(isPlaying)
    {
      FlutterRadio.play(url: streamURL);
      print("started playing");
    }
    else
    {
      FlutterRadio.pause(url: streamURL);
      print("stopped playing");
    }
  }

  void nowPlayingUpdate() async
  {
    final response = await http.get("http://37.187.112.164:8000/stats");
    final responceDoc = xml.parse(response.body);

    setState(() {
      nowPlayingTitle = responceDoc.findAllElements("SONGTITLE").single.text;

    });
  }

  @override
  void initState() {
    super.initState();
    audioStart();
    nowPlayingUpdate();
  }

  Future<void> audioStart() async {
    await FlutterRadio.audioStart();
    print('Audio Start OK');
  }

  @override
  Widget build(BuildContext context) {


    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Now Playing Song:',
              ),
              Text(
                nowPlayingTitle,
                style: Theme.of(context).textTheme.headline4,
              ),
              
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: playPauseRadio,
          tooltip: 'Play/Pause',
          child: Icon(Icons.play_arrow),
          backgroundColor: Colors.greenAccent,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0, // this will be set when a new tab is tapped
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.language),
              title: new Text('Главный'),
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.flare),
              title: new Text('Молодежный'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.contact_mail),
              title: Text('Дать Отзыв')
            )
          ],
        ),
      ),
    );
  }
}
