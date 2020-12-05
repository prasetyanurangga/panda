import 'package:panda/models/just_listen_model.dart';
import 'package:dio/dio.dart';
import 'custom_exception.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';

class ApiProvider{
  final String _endpoint = "https://listen-api.listennotes.com/api/v2/just_listen";
  final Dio _dio = Dio();

  Future<Response> getJustListen() async {
    Response response;
    try {
      response = await _dio.get(_endpoint, options: 
        Options(headers: {
          'X-ListenAPI-Key': 'YOUR_API_KEY',
        })
      );
    } on Error catch (e) {
      throw Exception('Failed to load post ' + e.toString());
    }
    return response;
  }
}