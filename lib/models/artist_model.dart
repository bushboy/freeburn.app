import 'package:meta/meta.dart';

@immutable
class ArtistModel {
  final String id;
  final String name;

  //final int? playcount;
  //final int? listeners;
  //final bool? isStreamable;
  final String description;
  final String genre;
  final String imageUrl;

  const ArtistModel({required this.id,
    required this.name,
    required this.description,
    required this.genre,
    required this.imageUrl});

  ArtistModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        description = json['desc']??"",
        genre = json['genre'],
        imageUrl = json['image'];
}
