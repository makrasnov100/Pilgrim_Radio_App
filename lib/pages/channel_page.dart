
import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:voice_of_pilgrim/UI/circular_share_buttons.dart';


import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class ChannelPage extends StatefulWidget {
  String streamURL;
  String statsURL;
  int streamId;

  ChannelPage({Key key, this.streamURL, this.statsURL, this.streamId}) : super(key: key);

  var state = _ChannelPageState();

  setAsCurrrentChannel() async
  {
    AudioService.seekTo(streamId);
  }

  @override
  _ChannelPageState createState()
  {
    return this.state = _ChannelPageState();
  }
}

class _ChannelPageState extends State<ChannelPage> {

  bool isCanChangePlayState = true;
  String curSongAuthor = "Radio Stream";
  String curSongTitle = "Loading...";

  bool isStreaming(MediaItem curMedia)
  {
    curSongAuthor = curMedia.artist;
    curSongTitle = curMedia.title;
    if(curSongTitle != "Unavaliable" && curSongTitle != "Loading...")
    {
      return true;
    }
    return false;
  }

  void onPlayPausePress() async
  {
    if(curSongTitle != "Unavaliable" && curSongTitle != "Loading..." && isCanChangePlayState)
    {
      isCanChangePlayState = false;
      await AudioService.play();
      setState(() {});
      isCanChangePlayState = true;
    }
  }

  Widget getFloatButton(PlaybackState curState)
  {
    Icon curIcon = Icon(Icons.play_arrow);
    if(curState.basicState == BasicPlaybackState.playing)
    {
      curIcon = Icon(Icons.pause);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          height: 80,
          width: 80,
          child: FittedBox(
            child: FloatingActionButton(
              onPressed: onPlayPausePress,
              tooltip: 'Play/Pause',
              child: curIcon,
              backgroundColor: Color.fromARGB(220, 59, 61, 126),//Theme.of(context).backgroundColor,
            ),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  @override
  void initState() { 
    super.initState();
    AudioService.seekTo(widget.streamId);
  }

  @override
  void dispose() {
    AudioService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder<MediaItem>(
        stream: AudioService.currentMediaItemStream,
        builder: (context, mediaSnapshot) {
          return StreamBuilder<PlaybackState>(
            stream: AudioService.playbackStateStream,
            builder: (context, snapshot) {
              return Scaffold(
                floatingActionButton: Visibility(
                  visible: isStreaming(mediaSnapshot.data??MediaItem(id: "NA", album: "None", title: "Radio Stream", artist: "Loading...")),
                  child: getFloatButton(snapshot.data??PlaybackState(basicState: BasicPlaybackState.stopped, actions: null)),
                ),
                floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
                body: Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      radius: 2,
                      colors: [Colors.white, Color.fromARGB(255, 183, 187, 210)],
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Flexible(
                          flex:1,
                          child: Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              height: 200,
                              child: Image.asset("assets/logo.png"),
                            ),
                          ),
                        ),
                        Flexible(
                          flex:1,
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  (mediaSnapshot.data ?? MediaItem(id: "", album: "", title: "", artist:"Radio Stream")).artist,
                                  style: Theme.of(context).textTheme.headline4,
                                ),
                                SizedBox(height: 5,),
                                Text(
                                  (mediaSnapshot.data ?? MediaItem(id: "", album: "", title: "Loading...", artist:"")).title,
                                  style: Theme.of(context).textTheme.headline6
                                ),
                                SizedBox(height: 40,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircularShareIconButton(
                                      iconData: FontAwesomeIcons.shareAlt,
                                      color: Colors.green,
                                      link: "Christian Radio Station: http://thevoiceofpilgrim.org/",
                                      isShare: true,
                                    ),
                                    CircularShareIconButton(
                                      iconData: FontAwesomeIcons.facebookF,
                                      color: Color.fromARGB(255, 66, 103, 178),
                                      link: "https://www.facebook.com/golos.piligrima/",
                                      isShare: false,
                                    ),
                                    CircularShareIconButton(
                                      iconData: FontAwesomeIcons.youtube,
                                      color: Color.fromARGB(255, 255, 0, 0),
                                      link: "https://www.youtube.com/playlist?list=PLyY7Cd7wQj3QmUB2Y3X8rlNGfi39hjQkE&fbclid=IwAR1uIlhaFRubaxt72JiB3dgW_wNdrRuqa4NPUAXI4FeBYMRfTNY__MDr5UM",
                                      isShare: false,
                                    ),
                                    CircularShareIconButton(
                                      iconData: FontAwesomeIcons.odnoklassniki,
                                      color: Color.fromARGB(255, 245, 130, 32),
                                      link: "https://www.ok.ru/group/54576674570348",
                                      isShare: false,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          );
        }
      ),
    );
  }
}