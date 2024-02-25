import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oxoo/apis/music_api.dart';
import 'package:oxoo/bloc/music/track_charts_page_event.dart';
import 'package:oxoo/bloc/music/track_charts_page_state.dart';
import 'package:oxoo/models/chart_model.dart';
import 'package:oxoo/models/track_model.dart';
import 'package:rxdart/rxdart.dart';

class TrackChartsPageBLoC  extends Bloc<TrackChartEvent, TrackChartsState>{
  final MusicApi apiClient;

  Stream<List<TrackModel>> get artists =>
      Stream.fromFuture(apiClient.getTrackCharts())
          .shareReplay(maxSize: 1);

  //TrackChartsPageBLoC(this._apiClient);

  TrackChartsPageBLoC({required this.apiClient}) : super(TrackChartsLoadingState());

  @override
  Stream<TrackChartsState> mapEventToState(TrackChartEvent event) async* {
    if (event is FetchTrackChartsData) {
      yield TrackChartsLoadingState();
      try {
        List<TrackModel> content = await apiClient.getTrackCharts();
        ChartModel model = new ChartModel(content);
        yield TrackChartsLoadedState(chart: model);
      } catch (_) {
        yield TrackChartsErrorState();
      }
    }
  }
}
