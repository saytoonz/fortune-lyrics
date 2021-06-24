import 'package:acr_cloud_sdk_example/core/providers.dart';
import 'package:acr_cloud_sdk_example/views/acr_cloud_recognizer.dart';
import 'package:acr_cloud_sdk_example/views/settings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomePage extends StatefulHookWidget {
  final SharedPreferences pref;
  HomePage(this.pref);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final deezerSongModel =
        useProvider(homeVM.select((v) => v.deezerSongModel));
    final youTubeVideo = useProvider(homeVM.select((v) => v.youTubeVideo));
    final spotifyTrackId = useProvider(homeVM.select((v) => v.spotifyTrackId));

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      drawer: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: ListView(
          children: [
            ListTile(
              title: Text("Settings"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (b) => SettingsPage(widget.pref),
                  ),
                );
              },
            )
          ],
        ),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: false,
                title: Container(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(0, 0, 0, .4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            child: Text(
                              deezerSongModel?.title ?? "",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              deezerSongModel?.artist?.name ?? "",
                              style: TextStyle(
                                fontSize: 12,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                background: deezerSongModel != null
                    ? CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: deezerSongModel.album?.coverBig ?? "",
                        placeholder: (context, url) => Center(
                          child: SpinKitFadingFour(
                            color: Colors.white,
                            size: 50.0,
                          ),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      )
                    : null,
              ),
              actions: [],
            ),
          ];
        },
        body: Center(
          child: Text("Sample Text"),
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Visibility(
            visible: deezerSongModel != null,
            child: FloatingActionButton(
              mini: true,
              backgroundColor: Colors.black,
              onPressed: () {},
            ),
          ),
          Visibility(
            visible: spotifyTrackId != null,
            child: FloatingActionButton(
              mini: true,
              backgroundColor: Colors.green,
              onPressed: () {},
            ),
          ),
          Visibility(
            visible: youTubeVideo != null,
            child: FloatingActionButton(
              mini: true,
              backgroundColor: Colors.red,
              onPressed: () {},
            ),
          ),
          FloatingActionButton(
            child: Icon(
              Icons.mic,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (b) => ACRCloudPage(pref: widget.pref),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
