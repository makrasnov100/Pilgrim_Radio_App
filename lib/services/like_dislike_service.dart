import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';

class SongRating
{
  String song;
  bool isGood;
  String radioType;

  SongRating(this.song, this.isGood, this.radioType);
}

class LikeDislikeService
{
  LikeDislikeService()
  {
    loadRatedSongs();
  }

  HashMap<String, bool> ratedSongs = HashMap<String, bool>();
  final rateSong = FieldValue.increment(1);

  void onRateSong(String fullName, bool isGood) async
  {
    bool needUpdate = true;
    if(ratedSongs.containsKey(fullName))
    {
      if(ratedSongs[fullName] == isGood)
      {
        needUpdate = false; //song rating already recorded
      }
    }

    //Cancel update if doesn't need one
    if(!needUpdate)
    {
      return;
    }

    //Split song info
    List<String> nameParts = fullName.split("|");
    if(nameParts.length != 3)
      return;

    //nameParts: combined to be used as a key in the rated songs dictionary
    // 0: song author
    // 1: song title
    // 2: radio type

    //Check if song entry exists in the database
    CollectionReference songColRef = Firestore.instance.collection("top_songs");
    QuerySnapshot songDocSnap = await Firestore.instance.collection("top_songs")
                                                        .where("radio_type", isEqualTo: nameParts[2])
                                                        .where("song_artist", isEqualTo: nameParts[0])
                                                        .where("song_title", isEqualTo: nameParts[1])
                                                        .getDocuments();

    //TODO: handle error if multiple copies of song is present in database

    if(songDocSnap.documents.length != 0) //Song already present in dictionary
    {
      if(isGood)
        songDocSnap.documents[0].reference.updateData({'song_likes':rateSong});
      else
        songDocSnap.documents[0].reference.updateData({'song_dislikes':rateSong});
    }
    else  //Song needs to be create prior to incrementing its
    {
      int songLikes = 0;
      int songDislikes = 1;
      if(isGood)
        songLikes = 1;
        songDislikes = 0;

      songColRef.add({'radio_type':nameParts[2],
                      'song_artist':nameParts[0],
                      'song_title':nameParts[1],
                      'song_likes':songLikes,
                      'song_dislikes':songDislikes});
    }
  }

  void loadRatedSongs()
  {
    //TODO: on start of service get all songs that the user has already rtated from divece (since no sign in)
  }
}