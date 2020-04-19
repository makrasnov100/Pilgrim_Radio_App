
import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:voice_of_pilgrim/UI/circular_share_buttons.dart';


import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class ChannelPage extends StatefulWidget {
  MediaItem mediaSnapshot;
  PlaybackState stateSnapshot;

  ChannelPage({Key key, this.mediaSnapshot, this.stateSnapshot}) : super(key: key);

  var state = _ChannelPageState();

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
    if(curSongTitle != "Unavaliable" && curSongTitle != "Loading..." && widget.stateSnapshot.basicState != BasicPlaybackState.none)
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
    
      AudioService.play();
      Future.delayed(const Duration(seconds: 1), () 
      {
        isCanChangePlayState = true;
      });
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
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Scaffold(
      floatingActionButton: Visibility(
        visible: isStreaming(widget.mediaSnapshot??MediaItem(id: "NA", album: "None", title: "Loading...", artist: "Radio Stream")),
        child: getFloatButton(widget.stateSnapshot??PlaybackState(basicState: BasicPlaybackState.none, actions: null)),
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
                        (widget.mediaSnapshot ?? MediaItem(id: "", album: "", title: "", artist:"Radio Stream")).artist,
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      SizedBox(height: 5,),
                      Text(
                        (widget.mediaSnapshot ?? MediaItem(id: "", album: "", title: "Loading...", artist:"")).title,
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
    )
  );
  }
}