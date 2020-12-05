import 'package:panda/models/just_listen_model.dart';
import 'package:panda/provider/response_data.dart';
import 'package:panda/provider/api_provider.dart';
import 'package:dio/dio.dart';
import 'dart:async';

class JustListenRepository{
  ApiProvider _apiProvider = ApiProvider();

  Future<ResponseData> getJustListens() async{
  	Response response = await _apiProvider.getJustListen();
  	JustListen responseJust = JustListen.fromJson(response.data);
  	if (responseJust == null) {
      return ResponseData.connectivityError();
    }

    if (response.statusCode == 200) {
      return ResponseData.success(responseJust);
    } else {
      return ResponseData.error("Error");
    }
  }


}