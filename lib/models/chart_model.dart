import 'track_model.dart';

class ChartModel {
  List<TrackModel>? chart = [];

  ChartModel(this.chart);

  ChartModel.fromJson(Map<String, dynamic> json){
    var jsonList = json['songs']['data'] as List;
    jsonList.map((e) => TrackModel.fromJson(e)).toList().forEach((element) {
      chart!.add(element);
    });
  }
}