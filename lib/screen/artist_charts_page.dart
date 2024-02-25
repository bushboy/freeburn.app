
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:oxoo/apis/music_api.dart';
import 'package:oxoo/models/artist_model.dart';
import 'package:oxoo/bloc/music/artists_charts_page_bloc.dart';
import 'package:oxoo/screen/music/screen.dart';
import 'package:oxoo/screen/subscription/plans_screen.dart';
import '../widgets/artist/charts_grid.dart';
import '../widgets/artist/charts_page.dart';

class ArtistChartsPage extends StatelessWidget {
  final ArtistsChartsPageBLoC _bloc = ArtistsChartsPageBLoC(MusicApi());

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ArtistModel>>(
      stream: _bloc.artists,
      builder: (context, snapshot) {
        return Screen(
          key : Key("Artists"),
          title: "Artists",
          child: _buildChild(context, snapshot),
        );
      },
    );
  }

  Widget _buildChild(
      BuildContext context, AsyncSnapshot<List<ArtistModel>> snapshot) {
    if (snapshot.hasError) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            "An error occured. Please retry in a bit.",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    } else {
      return ChartsPage<ArtistModel>(
        key: Key('ChartsPage'),
        items: snapshot.data??<ArtistModel>[],
        transform: (item) =>
            ChartItem(title: item.name, imageUrl: item.imageUrl,genre: item.genre),
            onTap: (artist) => Navigator.pushNamed(context, PlansScreen.route)
        /*onTap: (artist) => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ArtistDetailPage(artist: artist),
            )),*/
      );
    }
  }
}
