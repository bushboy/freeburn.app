import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:oxoo/models/chart_model.dart';

@immutable
abstract class TrackChartsState extends Equatable {}

class TrackChartsInitialState extends TrackChartsState {
  @override
  List<Object?> get props => [];
}

class TrackChartsLoadingState extends TrackChartsState {
  @override
  List<Object?> get props => [];
}

class TrackChartsLoadedState extends TrackChartsState {
  final ChartModel chart;
  TrackChartsLoadedState({required this.chart});

  @override
  List<Object> get props => [chart];
}

class TrackChartsErrorState extends TrackChartsState {
  @override
  List<Object?> get props => [];
}
