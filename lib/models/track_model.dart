import 'package:meta/meta.dart';

@immutable
class TrackModel {
   String? id;
   String? name;
   String? imageUrl;
   String? score;
   String? genre;
   String? position;

  TrackModel({ this.id,  this.name,  this.imageUrl,  this.score,this.genre, this.position});

  TrackModel.fromJson(Map<String, dynamic> json)
      : id = json['id'].toString(),
        name = "${json['title']} (${json['primary_artists']})",
        imageUrl = json['image'],
        score = json['score'].toString(),
        genre = json['genre'].toString(),
        position =json['position'].toString();
}
