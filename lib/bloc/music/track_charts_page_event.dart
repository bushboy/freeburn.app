import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class TrackChartEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchTrackChartsData extends TrackChartEvent {}
