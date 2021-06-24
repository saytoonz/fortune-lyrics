import 'dart:async';

import 'package:acr_cloud_sdk/acr_cloud_sdk.dart';
import 'package:fastlyrics/models/deezer_song_model.dart';
import 'package:fastlyrics/network_layer/api/song.dart';
import 'package:flutter/material.dart';

class HomeViewModel extends ChangeNotifier {
  final AcrCloudSdk arc = AcrCloudSdk();
  final SongAPI api = SongAPI();

  String _youTubeVideo;
  String get youTubeVideo => _youTubeVideo;

  String _spotifyTrackId;
  String get spotifyTrackId => _spotifyTrackId;

  DeezerSongModel _deezerSongModel;
  DeezerSongModel get deezerSongModel => _deezerSongModel;

  BuildContext _context;

  AnimationController _controller;
  AnimationController get controller => _controller;
  set setController(AnimationController c) {
    _controller = c;
    notifyListeners();
  }

  SongModel _songModel;
  SongModel get songModel => _songModel;
  set songModel(SongModel val) {
    _songModel = val;
    notifyListeners();
  }

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool val) {
    _loading = val;
    notifyListeners();
  }

  Future<void> init(BuildContext context) async {
    try {
      _context = context;

      arc
        ..init(
          host:
              'identify-eu-west-1.acrcloud.com', // obtain from https://www.acrcloud.com/
          accessKey:
              'df959d681a58461cf8193e340d9c8aa7', // obtain from https://www.acrcloud.com/
          accessSecret:
              'qAiJwwDOaBcKGn4MaO3eGi04PPoAjpPx6cDkUOCD', // obtain from https://www.acrcloud.com/
          setLog: false,
        )
        ..songModelStream.listen(searchSong);
    } catch (e) {
      print(e.toString());
    }
  }

  void start() async {
    try {
      _controller?.repeat();
      loading = true;
      await arc.start();
    } catch (e) {
      print(e.toString());
    }
  }

  void stop() async {
    try {
      _controller?.stop();
      loading = false;
      await arc.stop();
    } catch (e) {
      print(e.toString());
    }
  }

  void searchSong(SongModel song) async {
    var data = song.metadata;

    if (data != null && data.music.length > 0) {
      var req = await api
          .dataFromDeezer(data.music[0]?.externalMetadata?.deezer?.track?.id);
      _youTubeVideo = data.music[0]?.externalMetadata?.youTube?.video;
      _spotifyTrackId = data.music[0]?.externalMetadata?.spotify?.track?.id;

      req.fold(
        (l) => print(l.toString()),
        (songModel) {
          // showCupertinoModalBottomSheet(
          //     context: _context,
          //     builder: (_) {
          //       return SongDetailPage(songModel);
          // });

          _deezerSongModel = songModel;
          print(_deezerSongModel.toJson());
        },
      );
    }
    _controller?.stop();
    loading = false;
  }
}
