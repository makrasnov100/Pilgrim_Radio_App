import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

//This class grabs information that remains static throughout an app session when flutter fire has been initialized
class GeneralInfoService {
  //Information Age
  DateTime lastUpdated;
  Completer<bool> onInitDone = Completer<bool>();

  //Stream Information
  String russianServerStreamURL = "http://cast4.my-control-panel.com/proxy/anatoli/stream";
  String russianServerStatsURL = "http://cast4.my-control-panel.com/proxy/anatoli/stats";
  String englishServerStreamURL = "http://ca.rcast.net:8010/stream";
  String englishServerStatsURL = "http://ca.rcast.net:8010/stats";

  Future<void> initializeService() async {
    await syncCloudInfo();
  }

  Future<void> syncCloudInfo() async {
    //Stream info
    try {
      final streamDocSnapshot = await Firestore.instance.collection("General").document("stream").get();
      if (streamDocSnapshot.exists) {
        final appData = streamDocSnapshot.data;
        russianServerStreamURL = appData["russianServerStreamURL"];
        russianServerStatsURL = appData["russianServerStatsURL"];
        englishServerStreamURL = appData["englishServerStreamURL"];
        englishServerStatsURL = appData["englishServerStatsURL"];
      }
    } catch (e) {
      print(e);
    }

    lastUpdated = DateTime.now();
    if (!onInitDone.isCompleted) {
      onInitDone.complete(true);
    }
  }

  Future<bool> dataLoaded() async {
    if (onInitDone.isCompleted) {
      return Future<bool>.value(true);
    } else {
      return onInitDone.future;
    }
  }
}
