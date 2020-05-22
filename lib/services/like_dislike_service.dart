import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';

class SongRating
{
  String songArtist;
  String songTitle;
  String radioType;
  bool isGood;

  SongRating(this.songArtist, this.songTitle, this.radioType, this.isGood,);
}

class LikeDislikeService
{
  LikeDislikeService()
  {
    loadRatedSongs();
  }

  HashMap<String, SongRating> ratedSongs = HashMap<String, SongRating>();
  final rateStatUp = FieldValue.increment(1);
  final rateStatDown = FieldValue.increment(-1);


  Future<void> onRateSong(String fullName, bool isGood) async
  {
    bool needUpdate = true;
    if(ratedSongs.containsKey(fullName))
    {
      if(ratedSongs[fullName].isGood == isGood)
      {
        needUpdate = false; //song rating already
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
        songDocSnap.documents[0].reference.updateData({'song_likes':rateStatUp, 'song_dislikes':rateStatDown});
      else
        songDocSnap.documents[0].reference.updateData({'song_dislikes':rateStatUp, 'song_likes':rateStatDown});
    }
    else  //Song needs to be create prior to incrementing its
    {
      int songLikes = 0;
      int songDislikes = 1;
      if(isGood)
      {
        songLikes = 1;
        songDislikes = 0;
      }

      songColRef.add({'radio_type':nameParts[2],
                      'song_artist':nameParts[0],
                      'song_title':nameParts[1],
                      'song_likes':songLikes,
                      'song_dislikes':songDislikes});
    }

    ratedSongs[fullName] = SongRating(nameParts[0], nameParts[1], nameParts[2], isGood);

    return;
  }

  void loadRatedSongs()
  {
    //TODO: on start of service get all songs that the user has already rtated from divece (since no sign in)
  }
}