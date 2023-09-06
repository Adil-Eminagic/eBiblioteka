import 'dart:convert';

import 'package:http/http.dart';

import '../models/notification.dart';
import '../providers/base_provider.dart';
import '../utils/util.dart';

class NotificationProvider extends BaseProvider<Notif> {
 
 String? _mainBaseUrl;
  final String _mainEndpoint = "api/Notification/SendNotification";

  NotificationProvider() : super('Notifications'){
    _mainBaseUrl = const String.fromEnvironment("mainBaseUrl", defaultValue: "http://localhost:7138/");
  }


  @override
  Notif fromJson(data) {
    return Notif.fromJson(data);
  }

  Future<void> readNotfication(int notifId) async {
    var url = "${BaseProvider.baseUrl}$endpoint/MakeRead/$notifId";

    var uri = Uri.parse(url);

    var headers = createHeaders();

    Response response = await put(uri, headers: headers, body: null);

    if (isValidResponse(response)) {
    } else {
      throw Exception("Unknown error");
    }
  }

  
  Future<dynamic> sendRabbitNotification(dynamic object) async{
     var url = "$_mainBaseUrl$_mainEndpoint";
    
    var uri = Uri.parse(url);
    var jsonRequest = jsonEncode(object);

     String jwt = Autentification.token ?? '';

  String jwtAuth = "Bearer $jwt";
      var headers = {"Content-Type": "application/json","Authorization": jwtAuth};

    Response response = await  post(uri, headers: headers, body:jsonRequest );
    
    if(isValidResponse(response)) {
      var data = jsonDecode(response.body);
      
      return data;
    } else {
      throw  Exception("Unknown error");
    }
  }
}
