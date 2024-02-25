import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:oxoo/apis/music_api.dart';
import 'package:oxoo/screen/music/screen.dart';
import 'package:oxoo/screen/music/when_loading.dart';
import 'package:oxoo/models/track_model.dart';

import '../bloc/music/track_charts_page_bloc.dart';
import '../bloc/music/track_charts_page_event.dart';

class TrackChartsPage extends StatelessWidget {
  final NumberFormat _numberFormat = NumberFormat.compact();
  final TrackChartsPageBLoC _bloc = TrackChartsPageBLoC(apiClient: MusicApi());

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<TrackModel>>(
      stream: _bloc.artists,
      builder: (context, snapshot) {
        return Screen(key: Key("chart"),
          title: "Track chart",
          //child: _buildChild(context, snapshot),
          child: _buildTabs(context, snapshot),
        );
      },
    );
  }

  Widget _buildTabs(BuildContext context,AsyncSnapshot<List<TrackModel>> snapshot)
  {
    return DefaultTabController(
      initialIndex: 0,
      length: 6,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: //AppBar(
          //title: const Text('TabBar Widget'),
          //bottom:
          TabBar(
            labelColor: Colors.white,
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                child: _buildTab("All", Colors.black)),
              _buildTab("A", Colors.lightGreenAccent),
              _buildTab("D", Colors.blue),
              _buildTab("G", Colors.deepPurpleAccent),
              _buildTab("H", Colors.orangeAccent),
              _buildTab("R", Colors.red),
            ],
          ),
        //),
        body: TabBarView(
          children: <Widget>[
            Center(
              child: _buildChild(context,snapshot,"all"),
            ),
            Center(
              child: _buildChild(context,snapshot,"Alternative"),
            ),
            Center(
              child: _buildChild(context,snapshot,"Dance"),
            ),
            Center(
              child: _buildChild(context,snapshot,"Gospel"),
            ),
            Center(
              child: _buildChild(context,snapshot,"Hip Hop"),
            ),
            Center(
              child: _buildChild(context,snapshot,"RNB Soul"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChild(
      BuildContext context, AsyncSnapshot<List<TrackModel>> snapshot,String genre) {
    if (snapshot.hasError) {
      return _buildErrorMessage(context);
    } else if(genre == "all") {
      return WhenLoading(
        key : Key("chart"),
        isLoading: !snapshot.hasData,
        builder: () => _buildChartsPage(snapshot.data),
      );
    }
    else{
      return WhenLoading(
        key : Key(genre),
        isLoading: !snapshot.hasData,
        builder: () => _buildChartsPage(snapshot.data?.where((element) => element.genre==genre).toList()),
      );
    }
  }

  Widget _buildChartsPage(List<TrackModel>? tracks) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      itemCount: tracks?.length ?? 0,
      itemBuilder: (BuildContext context, int index) => ListTile(
            title: Text(tracks?[index].name ?? "none",style: TextStyle(color: Colors.white)),
            subtitle: Text("Position: ${index + 1} (${tracks?[index].genre})",style: TextStyle(color: Colors.white)),
            //subtitle: Text("Position: ${tracks?[index].position}",style: TextStyle(color: Colors.white)),
            leading: SizedBox(
              width: 50,
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: tracks?[index].imageUrl ??"",
                )
              ),
            ),
          ),
      separatorBuilder: (BuildContext context, int index) => Divider(),
    );
  }

  Widget _buildErrorMessage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Text(
          "An error occured. Please retry in a bit.",
          //style: Theme.of(context).textTheme.body1,
        ),
      ),
    );
  }

  Tab _buildTab(String title,  Color iconColor) {
    return Tab(
        child: Center(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: iconColor, width: 1)),
            width: 100,
            height: 100,
              child: Center(child: Text(title)),
          )
        )
    );
  }
}
