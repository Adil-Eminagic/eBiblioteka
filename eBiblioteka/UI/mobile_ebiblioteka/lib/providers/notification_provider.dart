
import 'dart:convert';

import '../models/notification.dart';
import '../providers/base_provider.dart';
import 'package:http/http.dart' as http;

import '../utils/util.dart';


class NotificationProvider extends BaseProvider<Notif> {
  String? _mainBaseUrl;
  final String _mainEndpoint = "api/Notification/SendNotification";

  NotificationProvider() : super('Notifications'){
    _mainBaseUrl = const String.fromEnvironment("mainBaseUrl", defaultValue: "http://10.0.2.2:7138/");
  }

  @override
  Notif fromJson(data) {
    return Notif.fromJson(data);
  }

  Future<dynamic> sendRabbitNotification(dynamic object) async{
     var url = "$_mainBaseUrl$_mainEndpoint";
    
    var uri = Uri.parse(url);
    var jsonRequest = jsonEncode(object);

     String jwt = Autentification.token ?? '';

  String jwtAuth = "Bearer $jwt";
      var headers = {"Content-Type": "application/json","Authorization": jwtAuth};

    http.Response response = await  http.post(uri, headers: headers, body:jsonRequest );
    
    if(isValidResponse(response)) {
      var data = jsonDecode(response.body);
      
      return data;
    } else {
      throw  Exception("Unknown error");
    }
  }

}
