import 'dart:async';

import 'package:acr_cloud_sdk/acr_cloud_sdk.dart';
import 'package:acr_cloud_sdk_example/core/models/deezer_song_model.dart';
import 'package:acr_cloud_sdk_example/core/network_layer/api/song.dart';
import 'package:acr_cloud_sdk_example/views/song_detail.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ACRCloudViewModel extends ChangeNotifier {
  late AnimationController controller;
  final AcrCloudSdk arc = AcrCloudSdk();
  final SongAPI api = SongAPI();

  String? _youTubeVideo;
  String? get youTubeVideo => _youTubeVideo;

  String? _spotifyTrackId;
  String? get spotifyTrackId => _spotifyTrackId;

  DeezerSongModel? _deezerSongModel;
  DeezerSongModel? get deezerSongModel => _deezerSongModel;

  BuildContext? _context;

  SongModel? _songModel;
  SongModel? get songModel => _songModel;
  set songModel(SongModel? val) {
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
              '92e5456a723332fd090e3ab70ece161e', // obtain from https://www.acrcloud.com/
          accessSecret:
              'orZqaXs6DkJglYXeypJC0YCh0a4LEjOoMdl8gNTJ', // obtain from https://www.acrcloud.com/
          setLog: false,
        )
        ..songModelStream.listen(searchSong);
    } catch (e) {
      print(e.toString());
    }
  }

  void start() async {
    try {
      controller.repeat();
      loading = true;
      await arc.start();
    } catch (e) {
      print(e.toString());
    }
  }

  void stop() async {
    try {
      controller.stop();
      loading = false;
      await arc.stop();
    } catch (e) {
      print(e.toString());
    }
  }

  void searchSong(SongModel song) async {
    var data = song.metadata;

    if (data != null && data.music!.length > 0) {
      var req = await api
          .dataFromDeezer(data.music?[0].externalMetadata?.deezer?.track?.id);

      _youTubeVideo = data.music?[0].externalMetadata?.youTube?.video;
      _spotifyTrackId = data.music?[0].externalMetadata?.spotify?.track?.id;
      req.fold(
        (l) => print(l.toString()),
        (songModel) {
          _deezerSongModel = songModel;
          // showCupertinoModalBottomSheet(
          //     context: _context!,
          //     builder: (_) {
          //       return SongDetailPage(_deezerSongModel);
          //     });
          Navigator.pop(_context!);
        },
      );
    }
    controller.stop();
    _loading = false;
  }
}
