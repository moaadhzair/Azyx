import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MediaPlayer extends StatefulWidget {

  final dynamic tracks;
  final String? Episode;

  const MediaPlayer({super.key, this.Episode, this.tracks});

  @override
  State<MediaPlayer> createState() => _MediaPlayerState();
}

class _MediaPlayerState extends State<MediaPlayer> with AutomaticKeepAliveClientMixin {

 BetterPlayerController? _betterPlayerController;
 

 @override
  void dispose() {
    _betterPlayerController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  @override 
  void didUpdateWidget(covariant MediaPlayer oldWidget){
    super.didUpdateWidget(oldWidget);
    if(widget.Episode != oldWidget.Episode) {
      _betterPlayerController?.dispose();
      initializePlayer();
    }
  }

  void initializePlayer() {
    if (_betterPlayerController != null) {
      _betterPlayerController!.dispose();
    }

    String videoUrl = widget.Episode!;

    if (widget.tracks == null) {
      print('Tracks are not available');
      return;
    }

    var subtitles = widget.tracks.map<BetterPlayerSubtitlesSource>((item) {
      return BetterPlayerSubtitlesSource(
        type: BetterPlayerSubtitlesSourceType.network,
        name: item['label'] ?? 'Unknown',
        urls: [item['file']],
      );
    }).toList();

    var betterPlayerConfiguration = const BetterPlayerConfiguration(
      controlsConfiguration: BetterPlayerControlsConfiguration(
          playerTheme: BetterPlayerTheme.cupertino),
      autoPlay: false,
    );

    BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      videoUrl,
      subtitles: subtitles,
    );

    setState(() {
      _betterPlayerController = BetterPlayerController(
        betterPlayerConfiguration,
        betterPlayerDataSource: betterPlayerDataSource,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if(widget.Episode == null || widget.tracks == null){
      return Center(child: CircularProgressIndicator());
    }
    return AspectRatio(
            aspectRatio: 16 / 9,
            child: _betterPlayerController != null
                ? BetterPlayer(controller: _betterPlayerController!)
                : const Center(
                    child:
                        CircularProgressIndicator()), // Handle case where player is not yet initialized
          );
  }

  @override
  bool get wantKeepAlive => true;
  
}