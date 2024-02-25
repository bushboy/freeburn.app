import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:oxoo/widgets/artist/tappable_image.dart';

class ChartItem {
  final String title;
  final String imageUrl;
  final String genre;

  const ChartItem({required this.title, required this.imageUrl,required this.genre})
      : assert(title != null),
        assert(imageUrl != null);
}

class ChartsGrid extends StatelessWidget {
  final List<ChartItem> items;
  final Function(int) onTap;

  const ChartsGrid({required Key key, required this.items, required this.onTap})
      : assert(items != null),
        assert(onTap != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.symmetric(vertical: 12.0),
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        final item = items[index];

        return TappableImage(
          key: Key("Tappable"),
          onTap: () => onTap(index),
          child: Stack(
            children: [
              Positioned(
                left: 0.0,
                top: 0.0,
                child:  SizedBox(
                  width: 200,
                  child: CachedNetworkImage(
                    imageUrl: item.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 0.0,
                left: 0.0,
                right: 0.0,
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("${item.title} (${item.genre.substring(0,1)})", style: TextStyle(color: Colors.white),),
                  ),
                  decoration: BoxDecoration(color: genreColor(item.genre)),
                ),
              )
            ],
          ),
        );
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.0,
        mainAxisSpacing: 12.0,
      ),
    );
  }

  Color genreColor (String genre){
    if(genre == "Alternative")
        return Colors.lightGreenAccent;
    else if(genre == "Dance")
      return Colors.blue;
    else if (genre == "Gospel")
      return Colors.deepPurpleAccent;
    else if (genre == "Hip Hop")
      return Colors.orangeAccent;
    else
      return Colors.redAccent;

  }
}
