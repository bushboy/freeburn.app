import 'package:oxoo/models/artist_model.dart';
import 'package:rxdart/rxdart.dart';

import '../../apis/music_api.dart';

class ArtistsChartsPageBLoC {
  MusicApi musicApi;

  Stream<List<ArtistModel>> get artists =>
      Stream.fromFuture(musicApi.getArtistList())
          .shareReplay(maxSize: 1);

  ArtistsChartsPageBLoC(this.musicApi) : assert(musicApi != null) {
  }
}
