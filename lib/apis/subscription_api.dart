import 'dart:io';
import 'dart:typed_data';
import 'package:dart_des/dart_des.dart';
import 'package:dio/dio.dart';
import '../../network/api_configuration.dart';
import 'dart:convert';

import '../models/plan_model.dart';

class SubscritionApi{
  Dio dio = Dio();

  Future<List<PlanModel>> getPlans() async {
    dio.options.headers = ConfigApi().getHeaders();
    try {
      final res = await dio.get("${ConfigApi().getApiUrl()}/all_package");
      if (res.statusCode == 200) {
        final List list = res.data['package'] as List;
        return list.map((package) => PlanModel.fromJson(package)).toList();
      }
      return List.empty();
    }
    catch(e){
      return List.empty();
    }
  }

}