import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:oxoo/server/repository.dart';
import 'package:oxoo/widgets/home_screen/country_item.dart';
import 'package:provider/provider.dart';
import '../../models/configuration.dart';
import '../../models/home_content.dart';
import '../../widgets/banner_ads.dart';
import '../models/user_model.dart';
import '../service/authentication_service.dart';
import '../service/get_config_service.dart';
import '../style/theme.dart';
import '../utils/loadingIndicator.dart';
import '../widgets/home_screen/features_genre_movies_item.dart';
import '../widgets/home_screen/genre_item.dart';
import '../widgets/home_screen/live_tv_item.dart';
import '../widgets/home_screen/movie_item.dart';
import '../widgets/home_screen/slider.dart';
import '../widgets/home_screen/tv_series_item.dart';
import '../strings.dart';
import '../widgets/live_mp4_video_player.dart';
import '../widgets/movie_details_video_player.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var appModeBox = Hive.box('appModeBox');
  bool? isDark;
  late Future<HomeContent> _homeContent;

  @override
  void initState() {
    super.initState();
    isDark = appModeBox.get('isDark') ?? false;
    _homeContent = Repository().getHomeContent();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final configService = Provider.of<GetConfigService>(context);

    AuthUser? authUser = authService.getUser();
    PaymentConfig? paymentConfig = configService.paymentConfig();
    AppConfig? appConfig = configService.appConfig();

    return Scaffold(
      backgroundColor: isDark! ? CustomTheme.primaryColorDark : Colors.transparent,
      body: FutureBuilder<HomeContent>(
        future: _homeContent,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return buildUI(context: context, authUser: authUser, paymentConfig: paymentConfig, appConfig: appConfig, homeContent: snapshot.data);
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                AppContent.somethingWentWrong,
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return Center(
            child: spinkit,
          );
        },
      ),
      // body: BlocBuilder<HomeContentBloc, HomeContentState>(
      //   builder: (context, state) {
      //     if (state is HomeContentLoadingState) {
      //       BlocProvider.of<HomeContentBloc>(context)..add(FetchHomeContentData());
      //     } else if (state is HomeContentErrorState) {
      //       return Center(
      //         child: Text(AppContent.somethingWentWrong),
      //       );
      //     } else if (state is HomeContentLoadedState) {
      //       printLog("--------home content data loaded");

      //       return buildUI(context: context, authUser: authUser, paymentConfig: paymentConfig, homeContent: state.homeContent);
      //     }
      //     return Center(child: spinkit);
      //   },
      // ),
    );
  }

  Widget buildUI({BuildContext? context, PaymentConfig? paymentConfig, AuthUser? authUser, AppConfig? appConfig, required HomeContent homeContent}) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: Container(
            margin: EdgeInsets.only(top: 5.0, bottom: 0),
            //child: ImageSlider(homeContent.slider),
            child: CachedNetworkImage(
                imageUrl: "https://freeburnmusic.com/uploads/ads/2.jpg",
                fit: BoxFit.cover,
              ),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            margin: EdgeInsets.only(top: 20,left: 15,right: 15, bottom: 0),
            child: Text(
              AppContent.about_1,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            margin: EdgeInsets.only(top: 0,left: 15,right: 15, bottom: 0),
            child: Text(
              AppContent.about_2,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            margin: EdgeInsets.only(top: 0,left: 15,right: 15, bottom: 0),
            child: Text(
              AppContent.about_3,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        /*SliverToBoxAdapter(
          child: Container(
            margin: EdgeInsets.only(top: 5.0, bottom: 0),
            //child: ImageSlider(homeContent.slider),
            child: CachedNetworkImage(
              imageUrl: "https://www.freeburnmusic.co.za/sitepad-data/uploads/2022/09/1597888440899.jpg",
              fit: BoxFit.cover,
            ),
          ),
        ),
        SliverToBoxAdapter(
          //child: Container(
            //margin: EdgeInsets.only(top: 0, bottom: 50),
            child: ImageSlider(homeContent.slider),
            child: VideoPlayerWidget(videoUrl: "https://mytaxi.dedicated.co.za:8093/api/video/promo/" + (Random().nextInt(4) + 3).toString()),
            //child: MovieDetailsVideoPlayerWidget(videoUrl: "https://mytaxi.dedicated.co.za:8093/api/video/promo/" + Random().nextInt(4).toString()),
          //),
        ),*/
        SliverToBoxAdapter(
          child: BannerAds(
            isDark: isDark,
          ),
        ),

        //country
        if (appConfig!.countryVisible)
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.only(top: 5, bottom: 5),
              child: HomeScreenCountryList(countryList: homeContent.allCountry, isDark: isDark!),
            ),
          ),

        //genre
        /*if (appConfig.genreVisible)
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.only(top: 5, bottom: 5),
              child: HomeScreenGenreList(
                genreList: homeContent.allGenre,
                isDark: isDark,
              ),
            ),
          ),*/
        //Featured TV Channels
        /*SliverToBoxAdapter(
          child: Container(
            margin: EdgeInsets.only(top: 5, bottom: 5),
            child: HomeScreenLiveTVList(
                tvList: homeContent.featuredTvChannel,
                title: AppContent.featuredTvChannels,
                isSearchWidget: false,
                isDark: isDark,
                isFromHomeScreen: true),
          ),
        ),*/
        // was on
        /*SliverToBoxAdapter(
          child: Container(
            margin: EdgeInsets.only(top: 2, bottom: 15),
            child: HomeScreenSeriesList(
              latestTvSeries: homeContent.latestTvseries,
              title: AppContent.latestTvSeries,
              isDark: isDark,
            ),
          ),
        ),
        //Latest movies
        SliverToBoxAdapter(
          child: Container(
            margin: EdgeInsets.only(top: 2, bottom: 15),
            child: HomeScreenMovieList(
              latestMovies: homeContent.latestMovies,
              context: context,
              title: AppContent.latestMovies,
              isDark: isDark,
            ),
          ),
        ),

        HomeScreenGenreMoviesList(
          genreMoviesList: homeContent.featuresGenreAndMovie,
          isDark: isDark,
        ),*/
      ],
    );
  }
}
