import 'package:flutter_radio/flutter_radio.dart';
import 'package:voice_of_pilgrim/services/bg_audio_task.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:xml/xml.dart' as xml;

class RadioControlService {
  String streamURL;
  String statsURL;
  StatsType statsType;
  bool isPlaying;
  bool isInitialized;

  RadioControlService({this.streamURL = "", this.statsURL = "", this.isPlaying = false}) {
    isInitialized = false;
  }

  //TRUE - successfully initialized, FALSE - failed
  Future<bool> initializeService() async {
    try {
      await FlutterRadio.audioStart();
      isInitialized = true;
    } catch (e) {
      print("ERROR initializing radio sevice - " + e.toString());
      isInitialized = false;
      return false;
    }

    if (isPlaying) beginPlaying();

    return true;
  }

  Future<void> changeChannels(String streamURL, String statsURL, StatsType statsType) async {
    if (!isInitialized) if (!await initializeService()) return;

    this.streamURL = streamURL;
    this.statsURL = statsURL;
    this.statsType = statsType;

    if (isPlaying) {
      await pausePlaying();
      await beginPlaying();
    }
  }

  Future<void> onPlayPausePress() async {
    if (isPlaying)
      await pausePlaying();
    else
      await beginPlaying();
  }

  Future<void> beginPlaying() async {
    if (await FlutterRadio.isPlaying()) {
      isPlaying = true;
      return;
    }

    try {
      if (!isInitialized) if (!await initializeService()) throw Exception("Cant initialize radio service!");

      await FlutterRadio.play(url: streamURL);
      isPlaying = true;
    } catch (e) {
      isPlaying = await FlutterRadio.isPlaying();
      print("ERROR starting stream - " + e.toString());
    }
  }

  Future<void> pausePlaying() async {
    if (!(await FlutterRadio.isPlaying())) {
      isPlaying = false;
      return;
    }

    try {
      if (!isInitialized) if (!await initializeService()) throw Exception("Cant initialize radio service!");
      await FlutterRadio.pause(url: streamURL);
      isPlaying = false;
    } catch (e) {
      isPlaying = await FlutterRadio.isPlaying();
      print("ERROR pausing stream - " + e.toString());
    }
  }

  Future<void> stopRadio() {
    FlutterRadio.stop();
  }

  Future<String> readResponse(HttpClientResponse response) {
    var completer = new Completer<String>();
    var contents = new StringBuffer();
    response.transform(utf8.decoder).listen((data) {
      contents.write(data);
    }, onDone: () => completer.complete(contents.toString()));
    return completer.future;
  }

  //Provides a list of song info 0 - author, 1 - title
  Future<List<String>> updateStats() async {
    if (statsType == StatsType.json) {
      return updateJSONStats();
    } else if (statsType == StatsType.xml) {
      return updateXMLStats();
    } else {
      return ["Radio Stream", "Unavaliable"];
    }
  }

  Future<List<String>> updateXMLStats() async {
    try {
      //Retrieving info
      final client = new HttpClient();
      final request = await client.getUrl(Uri.parse(statsURL));
      HttpClientResponse response = await request.close();
      String responceText = await readResponse(response);
      final responceDoc = xml.parse(responceText);
      String songInfo = responceDoc.findAllElements("SONGTITLE").single.text;

      if (songInfo == "") throw Exception("Empty song stats returned");

      return parseSongInfo(songInfo);
    } catch (e) {
      print("ERROR retrieving song stats - " + e.toString());
      return ["Radio Stream", "Unavaliable"];
    }
  }

  Future<List<String>> updateJSONStats() async {
    try {
      //Retrieving info
      final client = new HttpClient();
      final request = await client.getUrl(Uri.parse(statsURL));
      HttpClientResponse response = await request.close();
      String responceText = await readResponse(response);

      //converting to json
      Map<String, dynamic> jsonMap = json.decode(responceText);
      Map<String, dynamic> serverInfo = jsonMap["icestats"];
      Map<String, dynamic> sourceInfo = serverInfo["source"];

      String songInfo = sourceInfo["title"];
      return parseSongInfo(songInfo);
    } catch (e) {
      print("ERROR retrieving song stats - " + e.toString());
      return ["Radio Stream", "Unavaliable"];
    }
  }

  List<String> parseSongInfo(String songInfo) {
    //Parsing song info
    int splitIdx = songInfo.indexOf(" - ");

    if (splitIdx == -1) {
      return ["Radio Stream", "Unavaliable"];
    }

    List<String> result = List<String>();
    if (splitIdx == -1) {
      result.add("Radio Stream");
      result.add(songInfo);
    } else {
      result.add(songInfo.substring(0, splitIdx));
      result.add(songInfo.substring(splitIdx + 3, songInfo.length));
    }

    return result;
  }
}
