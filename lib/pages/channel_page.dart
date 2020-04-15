
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:voice_of_pilgrim/UI/circular_share_buttons.dart';
import 'package:voice_of_pilgrim/services/locator.dart';
import 'package:voice_of_pilgrim/services/radio_control_service.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class ChannelPage extends StatefulWidget {
  String streamURL;
  String statsURL;

  ChannelPage({Key key, this.streamURL, this.statsURL}) : super(key: key);

  var state = _ChannelPageState();

  setAsCurrrentChannel() async
  {
    getIt<RadioControlService>().changeChannels(streamURL, statsURL);
    state.updateSongInfo(isForced:true);
  }

  @override
  _ChannelPageState createState()
  {
    return this.state = _ChannelPageState();
  }
}

class _ChannelPageState extends State<ChannelPage> {

  Timer timer;
  bool isStreaming = false;
  bool isCanChangePlayState = true;
  String curSongAuthor = "Radio Team";
  String curSongTitle = "Loading...";

  void onPlayPausePress() async
  {
    if(curSongTitle != "Radio Stream Unavaliable" && curSongTitle != "Loading..." && isCanChangePlayState)
    {
      isCanChangePlayState = false;
      await getIt<RadioControlService>().onPlayPausePress();
      setState(() {});
      isCanChangePlayState = true;
    }
  }

  FloatingActionButton getFloatButton()
  {
    Icon curIcon = Icon(Icons.play_arrow);
    if(getIt<RadioControlService>().isPlaying)
    {
      curIcon = Icon(Icons.pause);
    }

    return FloatingActionButton(
      onPressed: onPlayPausePress,
      tooltip: 'Play/Pause',
      child: curIcon,
      backgroundColor: Color.fromARGB(220, 59, 61, 126),//Theme.of(context).backgroundColor,
    );
  }

  void updateSongInfo({isForced = false}) async
  {

    if(!this.mounted && !isForced)
    {
      return;
    }

    List<String> songInfo = await getIt<RadioControlService>().updateStats();

    if(songInfo.length > 0)
      curSongAuthor = songInfo[0];
    else
      curSongAuthor = "";

    if(songInfo.length > 1)
      curSongTitle = songInfo[1];
    else
      curSongTitle = "";

    if(curSongTitle == "Radio Stream Unavaliable")
      isStreaming = false;
    else
      isStreaming = true;

    if(this.mounted)
      setState(() {});
  }

  @override
  void initState() { 
    super.initState();
    getIt<RadioControlService>().changeChannels(widget.streamURL, widget.statsURL);
    timer = Timer.periodic(new Duration(seconds: 5), (timer) {
      updateSongInfo();
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Scaffold(
        floatingActionButton: Visibility(
          visible: isStreaming,
          child: getFloatButton(),
        ),
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
                          curSongAuthor,
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        SizedBox(height: 5,),
                        Text(
                          curSongTitle,
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
                              link: "https://www.youtube.com/channel/UCv-wXL-nx_ahH3kOR4jM7vQ",
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
      ),
    );
  }
}