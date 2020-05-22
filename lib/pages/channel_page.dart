
import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:voice_of_pilgrim/UI/circular_share_buttons.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:voice_of_pilgrim/services/SizeConfig.dart';
import 'package:voice_of_pilgrim/services/bg_audio_task.dart';
import 'package:voice_of_pilgrim/services/like_dislike_service.dart';

import 'package:voice_of_pilgrim/services/locator.dart';

class ChannelPage extends StatefulWidget {
  MediaItem mediaSnapshot;
  PlaybackState stateSnapshot;
  int channelID;

  ChannelPage({Key key, this.mediaSnapshot, this.stateSnapshot, this.channelID}) : super(key: key);

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

  bool isStreaming({MediaItem curMedia, PlaybackState curState})
  {
    curSongAuthor = curMedia.artist;
    curSongTitle = curMedia.title;
    if(curSongTitle != "Unavaliable" && curSongTitle != "Loading..." && (curState != null && curState.basicState != BasicPlaybackState.none))
    {
      return true;
    }
    if(curState != null && curState.basicState == BasicPlaybackState.stopped)
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

      if (widget.stateSnapshot == null)
      {
        await AudioService.start(backgroundTaskEntrypoint: myBackgroundAudioTaskEntrypoint);
        AudioService.seekTo(widget.channelID);
        Future.delayed(const Duration(seconds: 1), () 
        {
          isCanChangePlayState = true;
        });
      } else if (widget.stateSnapshot.basicState == BasicPlaybackState.paused ||
                 widget.stateSnapshot.basicState == BasicPlaybackState.playing)
      {
        AudioService.play();
        Future.delayed(const Duration(seconds: 1), () 
        {
          isCanChangePlayState = true;
        });
      }
    }
  }

  String getChennelType()
  {
    // Todo: make a service that consolidates this type of info
    String channelType = "russian";
    if(widget.channelID == 1)
      channelType = "english";
    return channelType;
  }

  void onDislikeSong()
  {
    String channelType = getChennelType();
    getIt<LikeDislikeService>().onRateSong(curSongAuthor+"|"+curSongTitle+'|'+channelType, false);
  }

  void onLikeSong()
  {
    String channelType = getChennelType();
    getIt<LikeDislikeService>().onRateSong(curSongAuthor+"|"+curSongTitle+'|'+channelType, true);
  }

  Widget getFloatButton(PlaybackState curState)
  {
    Icon curIcon = Icon(Icons.play_arrow);
    if(curState.basicState == BasicPlaybackState.playing)
    {
      curIcon = Icon(Icons.pause);
    }
    if(curState.basicState == BasicPlaybackState.stopped)
    {
      curIcon = Icon(Icons.sync);
    }

    return Row(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Spacer(),
            SizedBox(
              width: SizeConfig.screenWidth,
              child: Row(
                children: [
                  Spacer(flex:4),
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: OutlineButton(
                      onPressed: onDislikeSong,
                      borderSide: BorderSide(color: Colors.red, width: 4),
                      highlightedBorderColor: Colors.pinkAccent,
                      shape: CircleBorder(),
                      child: Icon(
                        Icons.thumb_down, 
                        size: SizeConfig.safeBlockVertical * 3,
                        color: Colors.redAccent,),
                    ),
                  ),
                  Spacer(flex:1),
                  Container(
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
                  Spacer(flex:1),
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: OutlineButton(
                      onPressed: onLikeSong,
                      highlightedBorderColor: Colors.greenAccent,
                      borderSide: BorderSide(color: Colors.green, width: 4),
                      shape: CircleBorder(),
                      child: Icon(
                        Icons.thumb_up, 
                        size: SizeConfig.safeBlockVertical * 3,
                        color: Colors.green),
                    ),
                  ),
                  Spacer(flex:4),
                ],
              ),
            ),
          ],
        ),
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
    SizeConfig().init(context); //ui scaling object
    return Expanded(
      child: Scaffold(
      floatingActionButton: Visibility(
        visible: isStreaming(
          curMedia: widget.mediaSnapshot??MediaItem(id: "NA", album: "None", title: "Stopped", artist: "Radio Stream"),
          curState: widget.stateSnapshot??PlaybackState(basicState: BasicPlaybackState.stopped, actions: null),
        ),
        child: getFloatButton(widget.stateSnapshot??PlaybackState(basicState: BasicPlaybackState.stopped, actions: null)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            radius: 2,
            colors: [Colors.white, Color.fromARGB(255, 183, 187, 210)],
          ),
        ),
        child: Container(
          margin: new EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(
                flex: 1,
                child: Container(),
              ),
              Flexible(
                flex:5,
                child: SizedBox(
                  height: SizeConfig.safeBlockVertical * 27,
                  child: Image.asset("assets/logo.png"),
                ),
              ),
              Flexible(
                flex:8,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: FittedBox(
                          fit:BoxFit.fitWidth,
                          child: Text(
                            (widget.mediaSnapshot ?? MediaItem(id: "", album: "", title: "", artist:"Radio Stream")).artist,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headline4,
                          ),
                        ),
                      ),
                      SizedBox(height: 5,),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          (widget.mediaSnapshot ?? MediaItem(id: "", album: "", title: "Stopped", artist:"")).title,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline6
                        ),
                      ),
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularShareIconButton(
                            iconData: FontAwesomeIcons.shareAlt,
                            color: Colors.green,
                            link: "Christian Radio Station: http://thevoiceofpilgrim.org/",
                            isShare: true,
                          ),
                          SizedBox(width:10), 
                          CircularShareIconButton(
                            iconData: FontAwesomeIcons.facebookF,
                            color: Color.fromARGB(255, 66, 103, 178),
                            link: "https://www.facebook.com/golos.piligrima/",
                            isShare: false,
                          ),
                          SizedBox(width:10),
                          CircularShareIconButton(
                            iconData: FontAwesomeIcons.youtube,
                            color: Color.fromARGB(255, 255, 0, 0),
                            link: "https://www.youtube.com/playlist?list=PLyY7Cd7wQj3QmUB2Y3X8rlNGfi39hjQkE&fbclid=IwAR1uIlhaFRubaxt72JiB3dgW_wNdrRuqa4NPUAXI4FeBYMRfTNY__MDr5UM",
                            isShare: false,
                          ),
                          SizedBox(width:10),
                          CircularShareIconButton(
                            iconData: FontAwesomeIcons.odnoklassniki,
                            color: Color.fromARGB(255, 245, 130, 32),
                            link: "https://www.ok.ru/group/54576674570348",
                            isShare: false,
                          ),
                          SizedBox(width:10),
                          CircularShareIconButton(
                            iconData: FontAwesomeIcons.paypal,
                            color: Color.fromARGB(255, 0, 69, 124),
                            link: "https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=A94QT9EXLTBSL&source=url",
                            isShare: false,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                flex: 3,
                child: Container(),
              ),
            ],
          ),
        ),
      ),
    )
  );
  }
}