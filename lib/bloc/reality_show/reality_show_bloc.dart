import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/tv_series_details_model.dart';
import '../../server/repository.dart';

class RealityShowEvent {}

class GetRealityShowEvent extends RealityShowEvent {
  @required
  final seriesId;
  @required
  final userId;
  GetRealityShowEvent({this.seriesId, this.userId});
}

class RealityShowState {}

class RealityShowInitailState extends RealityShowState {}

class RealityShowIsNotLoading extends RealityShowState {}

class RealityShowIsLoaded extends RealityShowState {
  TvSeriesDetailsModel? tvSeriesDetailsModel;
  RealityShowIsLoaded({this.tvSeriesDetailsModel});
}

class RealityShowErrorState extends RealityShowState {
  final error;
  RealityShowErrorState({this.error});
}

class RealityShowBloc extends Bloc<RealityShowEvent, RealityShowState> {
  Repository repository;
  RealityShowBloc(this.repository) : super(RealityShowInitailState());

  RealityShowState get initialState => RealityShowInitailState();

  @override
  Stream<RealityShowState> mapEventToState(RealityShowEvent event) async* {
    if (event is GetRealityShowEvent) {
      yield RealityShowInitailState();
      try {
        TvSeriesDetailsModel? tvSeriesDetailsModel =
        await repository.getTvSeriesDetailsData(
            seriesId: event.seriesId, userId: event.userId);
        yield RealityShowIsLoaded(tvSeriesDetailsModel: tvSeriesDetailsModel);
      } catch (e) {
        yield RealityShowErrorState(error: e.toString());
      }
    }
  }
}
