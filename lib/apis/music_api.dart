import 'dart:io';
import 'dart:typed_data';
import 'package:dart_des/dart_des.dart';
import 'package:dio/dio.dart';
import '../../network/api_configuration.dart';
import 'dart:convert';
import 'package:oxoo/helpers/format.dart';
import 'package:logging/logging.dart';
import 'package:oxoo/helpers/extensions.dart';
import 'package:oxoo/helpers/image_resolution_modifier.dart';
import 'package:oxoo/models/track_model.dart';
import 'package:oxoo/models/artist_model.dart';

class MusicApi {
  Dio dio = Dio();

  static String decode(String input) {
    const String key = '38346591';
    final DES desECB = DES(key: key.codeUnits);

    final Uint8List encrypted = base64.decode(input);
    final List<int> decrypted = desECB.decrypt(encrypted);
    final String decoded = utf8
        .decode(decrypted)
        .replaceAll(RegExp(r'\.mp4.*'), '.mp4')
        .replaceAll(RegExp(r'\.m4a.*'), '.m4a');
    return decoded.replaceAll('http:', 'https:');
  }

  Future<Map> fetchSongSearchResults({
    required String searchQuery,
    int count = 20,
    int page = 1,
  }) async {
    dio.options.headers = ConfigApi().getHeaders();
    try {
      final res = await dio.get("${ConfigApi().getApiUrl()}/find_songs?query=$searchQuery&p=$page");
      if (res.statusCode == 200) {
        //final Map getMain = json.decode(res.data.toString()) as Map;
        final List responseList = res.data['songs']['data'] as List;
        return {
          'songs':
          await formatSongsResponse(responseList, 'song'),
          'error': '',
        };
      } else {
        return {
          'songs': List.empty(),
          'error': res.data,
        };
      }
    } catch (e) {
      Logger.root.severe('Error in fetchSongSearchResults: $e');
      return {
        'songs': List.empty(),
        'error': e,
      };
    }
  }

  Future<List<TrackModel>> getTrackCharts() async {
    dio.options.headers = ConfigApi().getHeaders();
    try {
      //final uri = await _createGetUri('chart.gettoptracks');
      final res = await dio.get("${ConfigApi().getApiUrl()}/get_songs_chart");
      if (res.statusCode == 200) {
          final List list = res.data['songs']['data'] as List;
          //Map<String, dynamic> object = data;
          //List<dynamic> list = object['tracks']['track'];
          return list.map((track) => TrackModel.fromJson(track)).toList();
      }
      return List.empty();
    }
    catch(e){
      return List.empty();
    }
  }

  Future<List<ArtistModel>> getArtistList() async {
    dio.options.headers = ConfigApi().getHeaders();
    try {
      //final uri = await _createGetUri('chart.getartists');
      final res = await dio.get("${ConfigApi().getApiUrl()}/get_artist_list");
      if (res.statusCode == 200) {
        final List list = res.data['artists']['data'] as List;
        return list.map((artist) => ArtistModel.fromJson(artist)).toList();
      }
      return List.empty();
    }
    catch(e){
      return List.empty();
    }
  }

  /*Future<List<Track>> getTopTracks(String id) async {
    final uri = await _createGetUri('artist.gettoptracks', { 'mbid': id });
    return _get(uri, (data) {
      Map<String, dynamic> object = data;
      List<dynamic> list = object['toptracks']['track'];
      return list.map((track) => Track.fromJson(track)).toList();
    });
  }*/

  static Future<List> formatSongsResponse(
      List responseList,
      String type,
      ) async {
    final List searchedList = [];
    for (int i = 0; i < responseList.length; i++) {
      Map? response;
      switch (type) {
        case 'song':
        case 'album':
        case 'playlist':
        case 'show':
        case 'mix':
          response = await formatSingleSongResponse(responseList[i] as Map);
          break;
        default:
          break;
      }

      if (response != null && response.containsKey('Error')) {
        Logger.root.severe(
          'Error at index $i inside FormatSongsResponse: ${response["Error"]}',
        );
      } else {
        if (response != null) {
          searchedList.add(response);
        }
      }
    }
    return searchedList;
  }

  static Future<Map> formatSingleSongResponse(Map response) async {
    // Map cachedSong = Hive.box('cache').get(response['id']);
    // if (cachedSong != null) {
    //   return cachedSong;
    // }
    try {
      return {
        'id': response['id'],
        'type': response['type'],
        'album': response['album'].toString().unescape(),
        'year': response['year'],
        'duration': response['length'],
        'language': response['language'].toString().capitalize(),
        'genre': response['language'].toString().capitalize(),
        '320kbps': response['320kbps'],
        'has_lyrics': response['has_lyrics'],
        'lyrics_snippet':
        response['lyrics_snippet'].toString().unescape(),
        'release_date': response['release_date'],
        'album_id': response['albumid'],
        'subtitle': response['description'].toString().unescape(),
        'title': response['title'].toString().unescape(),
        'artist': response['primary_artists'],
        'album_artist': response['primary_artists'],
        'image': getImageUrl(response['image'].toString()),
        'perma_url': response['url'],
        //'url': decode(response['more_info']['encrypted_media_url'].toString()),
        'url' : response['url']
      };
      // Hive.box('cache').put(response['id'].toString(), info);
    } catch (e) {
      Logger.root.severe('Error inside FormatSingleSongResponse: $e');
      return {'Error': e};
    }
  }

  Future<List<Map>> fetchSearchResults(String searchQuery) async {
    final Map<String, List> result = {};
    final Map<int, String> position = {};
    List searchedAlbumList = [];
    List searchedPlaylistList = [];
    List searchedArtistList = [];
    List searchedTopQueryList = [];

    dio.options.headers = ConfigApi().getHeaders();
    try {
      final res = await dio.get("${ConfigApi().getApiUrl()}/find_albums?query=$searchQuery");
      if (res.statusCode == 200) {
        //final Map getMain = json.decode(res.data.toString()) as Map;
        final List responseList = res.data['albums']['data'] as List;
        searchedAlbumList =
        await formatAlbumResponse(responseList, 'album');
        if (searchedAlbumList.isNotEmpty) {
          result['Albums'] = searchedAlbumList;
        }
      }
    } catch (e) {
      Logger.root.severe('Error in fetchSongSearchResults: $e');
    }
    position[0] = 'Songs';
    position[1] = 'Albums';
    return [result, position];
  }

  Future<Map> fetchAlbumSongs(String albumId) async {
    dio.options.headers = ConfigApi().getHeaders();
    try {
      final res = await dio.get("${ConfigApi().getApiUrl()}/find_album_songs?query=$albumId");
      if (res.statusCode == 200) {
        final List responseList = res.data['songs']['data'] as List;
        return {
          'songs':
          await formatSongsResponse(responseList, 'album'),
          'error': '',
        };
      } else {
        return {
          'songs': List.empty(),
          'error': res.data,
        };
      }
    } catch (e) {
      Logger.root.severe('Error in fetchAlbumSongs: $e');
      return {
        'songs': List.empty(),
        'error': e,
      };
    }
  }

  Future<List<Map>> fetchAlbums({
    required String searchQuery,
    required String type,
    int count = 20,
    int page = 1,
  }) async {
    /*String? params;
    if (type == 'playlist') {
      params =
      'p=$page&q=$searchQuery&n=$count&${endpoints["playlistResults"]}';
    }
    if (type == 'album') {
      params = 'p=$page&q=$searchQuery&n=$count&${endpoints["albumResults"]}';
    }
    if (type == 'artist') {
      params = 'p=$page&q=$searchQuery&n=$count&${endpoints["artistResults"]}';
    }*/
    dio.options.headers = ConfigApi().getHeaders();
    final res = await dio.get("${ConfigApi().getApiUrl()}/find_artist_albums?query=$searchQuery");
    if (res.statusCode == 200) {
      final List responseList = res.data['albums']['data'] as List;
      return FormatResponse.formatAlbumResponse(responseList, type);
    }
    return List.empty();
  }

 /* Future<Map<String, List>> fetchArtistSongs({
    required String artistToken,
    String category = '',
    String sortOrder = '',
  }) async {
    final Map<String, List> data = {};
    final String params =
        '${endpoints["fromToken"]}&type=artist&p=&n_song=50&n_album=50&sub_type=&category=$category&sort_order=$sortOrder&includeMetaTags=0&token=$artistToken';
    final res = await getResponse(params);
    if (res.statusCode == 200) {
      final getMain = json.decode(res.body) as Map;
      final List topSongsResponseList = getMain['topSongs'] as List;
      final List latestReleaseResponseList = getMain['latest_release'] as List;
      final List topAlbumsResponseList = getMain['topAlbums'] as List;
      final List singlesResponseList = getMain['singles'] as List;
      final List dedicatedResponseList =
      getMain['dedicated_artist_playlist'] as List;
      final List featuredResponseList =
      getMain['featured_artist_playlist'] as List;
      final List similarArtistsResponseList = getMain['similarArtists'] as List;

      final List topSongsSearchedList =
      await FormatResponse.formatSongsResponse(
        topSongsResponseList,
        'song',
      );
      if (topSongsSearchedList.isNotEmpty) {
        data[getMain['modules']?['topSongs']?['title']?.toString() ??
            'Top Songs'] = topSongsSearchedList;
      }

      final List latestReleaseSearchedList =
      await FormatResponse.formatArtistTopAlbumsResponse(
        latestReleaseResponseList,
      );
      if (latestReleaseSearchedList.isNotEmpty) {
        data[getMain['modules']?['latest_release']?['title']?.toString() ??
            'Latest Releases'] = latestReleaseSearchedList;
      }

      final List topAlbumsSearchedList =
      await FormatResponse.formatArtistTopAlbumsResponse(
        topAlbumsResponseList,
      );
      if (topAlbumsSearchedList.isNotEmpty) {
        data[getMain['modules']?['topAlbums']?['title']?.toString() ??
            'Top Albums'] = topAlbumsSearchedList;
      }

      final List singlesSearchedList =
      await FormatResponse.formatArtistTopAlbumsResponse(
        singlesResponseList,
      );
      if (singlesSearchedList.isNotEmpty) {
        data[getMain['modules']?['singles']?['title']?.toString() ??
            'Singles'] = singlesSearchedList;
      }

      final List dedicatedSearchedList =
      await FormatResponse.formatArtistTopAlbumsResponse(
        dedicatedResponseList,
      );
      if (dedicatedSearchedList.isNotEmpty) {
        data[getMain['modules']?['dedicated_artist_playlist']?['title']
            ?.toString() ??
            'Dedicated Playlists'] = dedicatedSearchedList;
      }

      final List featuredSearchedList =
      await FormatResponse.formatArtistTopAlbumsResponse(
        featuredResponseList,
      );
      if (featuredSearchedList.isNotEmpty) {
        data[getMain['modules']?['featured_artist_playlist']?['title']
            ?.toString() ??
            'Featured Playlists'] = featuredSearchedList;
      }

      final List similarArtistsSearchedList =
      await FormatResponse.formatSimilarArtistsResponse(
        similarArtistsResponseList,
      );
      if (similarArtistsSearchedList.isNotEmpty) {
        data[getMain['modules']?['similarArtists']?['title']?.toString() ??
            'Similar Artists'] = similarArtistsSearchedList;
      }
    }
    return data;
  }*/

  static Future<List<Map>> formatAlbumResponse(
      List responseList,
      String type,
      ) async {
    final List<Map> searchedAlbumList = [];
    for (int i = 0; i < responseList.length; i++) {
      Map? response;
      switch (type) {
        case 'album':
          response = await formatSingleAlbumResponse(responseList[i] as Map);
          break;
        /*case 'artist':
          response = await formatSingleArtistResponse(responseList[i] as Map);
          break;
        case 'playlist':
          response = await formatSinglePlaylistResponse(responseList[i] as Map);
          break;
        case 'show':
          response = await formatSingleShowResponse(responseList[i] as Map);
          break;*/
      }
      if (response!.containsKey('Error')) {
        Logger.root.severe(
          'Error at index $i inside FormatAlbumResponse: ${response["Error"]}',
        );
      } else {
        searchedAlbumList.add(response);
      }
    }
    return searchedAlbumList;
  }

  static Future<Map> formatSingleAlbumResponse(Map response) async {
    try {
      return {
        'id': response['id'],
        'type': response['type'],
        'album': response['title'].toString().unescape(),
        'year': response['year'],
        'language':  null,
        'genre': response['genre'],
        'album_id': response['id'],
        'subtitle': response['description'],
        'title': response['title'].toString().unescape(),
        'artist': response['artist'] ,
        'album_artist': response['artist'] ,
        'image': getImageUrl(response['image'].toString()),
        'count': response['songs'],
      };
    } catch (e) {
      Logger.root.severe('Error inside formatSingleAlbumResponse: $e');
      return {'Error': e};
    }
  }

}