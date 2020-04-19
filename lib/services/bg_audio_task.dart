//REFERENCE: https://pub.dev/packages/audio_service#-example-tab-

import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:voice_of_pilgrim/services/radio_control_service.dart';

void myBackgroundAudioTaskEntrypoint() {
  AudioServiceBackground.run(() => BGAudioTask());
}

MediaControl playControl = MediaControl(
  androidIcon: 'drawable/ic_stat_play_arrow',
  label: 'Play',
  action: MediaAction.play,
);
MediaControl pauseControl = MediaControl(
  androidIcon: 'drawable/ic_stat_pause',
  label: 'Pause',
  action: MediaAction.pause,
);
MediaControl stopControl = MediaControl(
  androidIcon: 'drawable/ic_stat_stop',
  label: 'Stop',
  action: MediaAction.stop,
);

class BGAudioTask extends BackgroundAudioTask {


  //TODO: figure out how to not make this hard coded
  //Stream info
  List<String> streamURLs = ["http://37.187.112.164:8000/stream", "http://ca.rcast.net:8010/stream"];
  List<String> statsURLs = ["http://37.187.112.164:8000/stats", "http://ca.rcast.net:8010/stats"];

  RadioControlService radioControlService = RadioControlService();
  String prevTitle = "";
  String prevAuthor = "";

  MediaItem curSong = MediaItem(id: "None", album: "NA", title: "Radio Stream", artist: "Loading...");

  //Audio player play/pause state
  BasicPlaybackState get _basicState => AudioServiceBackground.state.basicState;
  MediaItem get mediaItem => curSong;

  Timer statsUpdater;

  Completer _stopStreamCompleter = Completer();
  Future _streamComplete()
  {
    if(_stopStreamCompleter.isCompleted)
      _stopStreamCompleter = Completer();
    return _stopStreamCompleter.future;
  }

  void updateSongInfo() async
  {
    if(radioControlService == null)
      return;

    List<String> songInfo = await radioControlService.updateStats();
    String curSongAuthor = "Radio Stream";
    String curSongTitle = "Loading...";

    if(songInfo.length > 0)
      curSongAuthor = songInfo[0];
    else
      curSongAuthor = "";

    if(songInfo.length > 1)
      curSongTitle = songInfo[1];
    else
      curSongTitle = "";

    if(prevAuthor != curSongAuthor || prevTitle != curSongTitle)
    {
      prevAuthor = curSongAuthor;
      prevTitle = curSongTitle;
      curSong = MediaItem(id: "NA", album: "None", title: curSongTitle, artist: curSongAuthor);
      AudioServiceBackground.setMediaItem(curSong);
    }
  }

  @override
  Future<void> onStart() async {

      //Begin the constantly updating stream
      statsUpdater = Timer.periodic(new Duration(seconds: 5), (timer) {
        updateSongInfo();
      });

      AudioServiceBackground.setState(        
        controls: [playControl],
        basicState: BasicPlaybackState.paused,
      );

      await _streamComplete();    //Begin the constantly updating stream
  }

  @override
  void onStop() {

    if (_basicState == BasicPlaybackState.stopped) 
      return;

    if(statsUpdater != null)
      statsUpdater.cancel();

    AudioServiceBackground.setState(
      controls: [],
      basicState: BasicPlaybackState.stopped,
    );
    radioControlService.stopRadio();
    _stopStreamCompleter.complete();
  }
  @override
  void onPlay() {

    playPause();
  }
  @override
  void onPause() {
    playPause();
  }

  @override
  void onClick(MediaButton button) {
    playPause();
  }

  @override
  void onSeekTo(int pos) async
  {
    if(pos >= 0 && pos < streamURLs.length && radioControlService != null)
    {
      await radioControlService.changeChannels(streamURLs[pos], statsURLs[pos]);
    }
  
    updateSongInfo();
  }

  Future<void> playPause() async
  {
    if(radioControlService == null)
      return;

    await radioControlService.onPlayPausePress();

    if (radioControlService.isPlaying)
    {
      //Perform playing operation
      await AudioServiceBackground.setState(
        controls: [pauseControl, stopControl],
        basicState: BasicPlaybackState.playing,
      );
    }
    else
    {
      //Perform pausing operation
      await AudioServiceBackground.setState(
        controls: [playControl],
        basicState: BasicPlaybackState.paused,
      );
    }
  }
}