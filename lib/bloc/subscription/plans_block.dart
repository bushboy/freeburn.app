import 'package:oxoo/apis/subscription_api.dart';
import 'package:oxoo/models/all_package_model.dart';
import 'package:oxoo/server/repository.dart';
import 'package:rxdart/rxdart.dart';

import '../../apis/music_api.dart';
import '../../models/plan_model.dart';

class PlansBLoC {
  SubscritionApi api;

  ReplayStream<List<PlanModel>> get packages =>
      Stream.fromFuture(api.getPlans())
          .shareReplay(maxSize: 1);

  PlansBLoC(this.api) : assert(PlansBLoC != null) {
  }
}