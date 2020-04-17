import 'package:flutter_radio/flutter_radio.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;


class RadioControlService
{
  String streamURL;
  String statsURL;
  bool isPlaying;
  bool isInitialized;

  RadioControlService({this.streamURL = "", this.statsURL = "", this.isPlaying = false})
  {
    isInitialized = false;
  }

  //TRUE - successfully initialized, FALSE - failed
  bool initializeService()
  {
    try{
      FlutterRadio.audioStart();
      isInitialized = true;
    } catch (e) {
      print("ERROR initializing radio sevice - " + e.toString());
      isInitialized = false;
      return false;
    }

    if(isPlaying)
      beginPlaying();

    return true;
  }

  Future<void> changeChannels(String streamURL, String statsURL) async
  {
    if(!isInitialized)
      if(!initializeService())
        return;

    this.streamURL = streamURL;
    this.statsURL = statsURL;

    if(isPlaying)
    {
      await pausePlaying();
      await beginPlaying();
    }
  }

  Future<void> onPlayPausePress() async
  {
    if(isPlaying)
      await pausePlaying();
    else
      await beginPlaying();
  }

  Future<void> beginPlaying() async
  {
    if(isPlaying || await FlutterRadio.isPlaying())
    {
      isPlaying = true;
      return;
    }

    try {
      if(!isInitialized)
        if(!initializeService())
          throw Exception("Cant initialize radio service!");

      FlutterRadio.play(url: streamURL);
      isPlaying = true;
    } catch (e) {
      isPlaying = false;
      print("ERROR starting stream - " + e.toString());
    }
  }

  Future<void> pausePlaying() async
  {
    if(!isPlaying || !(await FlutterRadio.isPlaying()))
    {
      
      isPlaying = false;
      return;
    }

    try{
      if(!isInitialized)
        if(!initializeService())
          throw Exception("Cant initialize radio service!");
      FlutterRadio.pause(url: streamURL);
      isPlaying = false;
    } catch (e) {
      isPlaying = true;
      print("ERROR pausing stream - " + e.toString());
    }
  }


  //Provides a list of song info 0 - author, 1 - title
  Future<List<String>> updateStats() async
  {
    try
    {
      //Retrieving info
      final response = await http.get(statsURL);
      final responceDoc = xml.parse(response.body);
      String songInfo = responceDoc.findAllElements("SONGTITLE").single.text;

      if(songInfo == "")
        throw Exception("Empty song stats returned");


      //Parsing song info
      int splitIdx = songInfo.indexOf(" - ");
      List<String> result = List<String>(); 
      if(splitIdx == -1)
      {
        result.add("Radio Stream");
        result.add(songInfo);
      }
      else
      {
        result.add(songInfo.substring(0, splitIdx));
        result.add(songInfo.substring(splitIdx+3, songInfo.length));
      }
      return result;
    }
    catch (e)
    {
      print("ERROR retrieving song stats - " + e.toString());
      return ["Radio Stream", "Unavaliable"];
    }
  }
}